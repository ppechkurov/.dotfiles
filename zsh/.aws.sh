function abl() (
	local region="${1:-us-east-2}"
	local since=${2:-10m}
	local queue=$3
	local border_label="AWS BATCH LOGS ${region:u}"
	local max_items=10

	function get_queues() {
		aws batch \
			describe-job-queues \
			--region $region \
			--query 'jobQueues[].jobQueueName'
	}

	function get_jobs() {
		aws batch list-jobs \
			--region $region \
			--job-queue $queue \
			--max-items $max_items \
			--query 'jobSummaryList[].jobId' |
			jq '. | { jobs: . }' |
			xargs -d \t -I{} aws batch describe-jobs \
				--region $region \
				--cli-input-json {} \
				--query 'jobs[].{
          id: jobId,
          status: status,
          database: [container.environment[?name==`DATABASE_NAME`].value][0][0]
          started: startedAt,
          stopped: stoppedAt,
          log: container.logStreamName
         }' |
			jq '.[] |= . + {
	       "started": (.started / 1000 | localtime | todate),
         "stopped": (if (.stopped == null) then null else (.stopped / 1000 | localtime | todate) end)
       } | sort_by(.started) | reverse'
	}

	if [ ! $queue ]; then
		queue=$(get_queues |
			jq '.[]' -r |
			fzf --border-label "$border_label" \
				--header-first \
				--header $'Select jobs queue') || return $?
	fi

	local file=$(mktemp)
	trap "rm -f $file" EXIT

	local job_id=$(get_jobs >$file |
		jq '.[].id' -r |
		fzf --border-label "$border_label" \
			--header $'Select job | CTRL-R to copy database name' \
			--header-first \
			--bind "ctrl-r:execute-silent(
          jq -r '.[] |
          select(.id==\"{}\") |
          .database' $file |
          xclip -selection clipboard)" \
			--preview-window right,60% \
			--preview-label '[ Job details ]' \
			--preview "jq -r '.[] |
          select(.id==\"{}\") |
          to_entries[] |
          [\"\(.key) \(.value)\"] |
          .[]' $file |
          column -t")

	[ ! $job_id ] && return $?

	local stream_name=$(jq -r ".[] | select(.id==\"$job_id\").log" $file)

	if [ ! $stream_name ]; then
		echo "Stream not found. Check selected region and queue."
		return 1
	fi

	aws logs tail \
		/aws/batch/job \
		--region $region \
		--log-stream-names $stream_name \
		--since $since \
		--format short \
		--follow
)
