RELEASE=$(echo "$CIRCLE_SHA1" | cut -c -7)
COMMIT_MESSAGE=$(git log --format=%B -n 1 "$CIRCLE_SHA1")
if [[ "$COMMIT_MESSAGE" =~ ^release[[:space:]]v[[:digit:]]+.[[:digit:]]+.[[:digit:]]+$ ]]; then
    RELEASE="${COMMIT_MESSAGE:9}"
fi

RELEASE="$RELEASE" npm run build