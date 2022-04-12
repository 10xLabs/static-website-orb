if [ "$VERSION" == "latest" ]; then
    curl -L https://get.pulumi.com/ | bash -s
else
    curl -L https://get.pulumi.com/ | bash -s -- --version "$VERSION"
fi

echo "export PATH=${HOME}/.pulumi/bin:$PATH" >> "$BASH_ENV"

# shellcheck source=/dev/null
source "$BASH_ENV"

cd "$WORKING_DIRECTORY" || exit
echo  "//npm.pkg.github.com/:_authToken=$GITHUB_PAT" > ./.npmrc
echo  "@10xLabs:registry=$NPM_GITHUB_REGISTRY" >> ./.npmrc
echo "registry=https://registry.npmjs.org" >> ./.npmrc
npm install
