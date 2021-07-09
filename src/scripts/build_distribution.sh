RELEASE=$(echo "$CIRCLE_SHA1" | cut -c -7)
COMMIT_MESSAGE=$(git log --format=%B -n 1 "$CIRCLE_SHA1")
if [[ "$COMMIT_MESSAGE" =~ ^Release[[:space:]]v[[:digit:]]+.[[:digit:]]+.[[:digit:]]+$ ]]; then
    RELEASE="${COMMIT_MESSAGE:9}"
fi

printenv
RELEASE="$RELEASE" npm run build
