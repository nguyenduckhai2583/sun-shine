#!/bin/bash
#
# Wrapper around `flutter build` that picks the right _env/<env>.env file.
#
#   ./_buildScripts/app_build.sh -env dev -platform apk
#   ./_buildScripts/app_build.sh -env prod -platform ipa -mode release \
#       -export-plist "$RUNNER_TEMP/ExportOptions.plist"
#
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Resolve the project root from this script's own location, so it can be run
# from anywhere — both `./_buildScripts/app_build.sh` and `cd _buildScripts && ./app_build.sh`.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_DIR="_env"

ENV="dev"
PLATFORM=""
BUILD_MODE="release"
IS_USE_FVM="y"
DO_CLEAN="n"
EXPORT_PLIST=""

usage() {
  echo "Usage: app_build.sh -platform <apk|appbundle|ios|ipa> [OPTIONS]"
  echo ""
  echo "  -platform     (Required) apk, appbundle, ios, ipa"
  echo "  -env          (Optional) Environment name. Default: $ENV"
  echo "  -mode         (Optional) debug, profile, release. Default: $BUILD_MODE"
  echo "  -fvm          (Optional) Use FVM? y/n. Default: $IS_USE_FVM"
  echo "  -clean        (Optional) Run flutter clean first? y/n. Default: $DO_CLEAN"
  echo "  -export-plist (Optional) ExportOptions.plist path, for ipa export"
  echo ""
  echo "Available environments: $(cd "$PROJECT_DIR/$ENV_DIR" 2>/dev/null && ls *.env 2>/dev/null | sed 's/\.env$//' | tr '\n' ' ')"
  exit 1
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -platform)     PLATFORM="$2"; shift 2 ;;
    -env)          ENV="$2"; shift 2 ;;
    -mode)         BUILD_MODE="$2"; shift 2 ;;
    -fvm)          IS_USE_FVM="$2"; shift 2 ;;
    -clean)        DO_CLEAN="$2"; shift 2 ;;
    -export-plist) EXPORT_PLIST="--export-options-plist=$2"; shift 2 ;;
    -h|--help)     usage ;;
    *)             echo -e "${RED}Unknown option: $1${NC}"; usage ;;
  esac
done

if [[ -z "$PLATFORM" ]]; then
  echo -e "${RED}Error: -platform is required.${NC}"
  usage
fi

cd "$PROJECT_DIR"

ENV_SOURCE="${ENV_DIR}/${ENV}.env"
if [[ ! -f "$ENV_SOURCE" ]]; then
  echo -e "${RED}Error: environment file not found: ${ENV_SOURCE}${NC}"
  usage
fi

if [[ "$IS_USE_FVM" == "y" ]]; then
  FLUTTER="fvm flutter"
else
  FLUTTER="flutter"
fi

echo -e "${GREEN}------- BUILD CONFIG -------${NC}"
echo -e "Platform:    ${GREEN}${PLATFORM}${NC}"
echo -e "Build mode:  ${GREEN}${BUILD_MODE}${NC}"
echo -e "Environment: ${GREEN}${ENV}${NC}  (${ENV_SOURCE})"
echo -e "Flutter:     ${GREEN}${FLUTTER}${NC}"
[[ -n "$EXPORT_PLIST" ]] && echo -e "Export plist: ${GREEN}${EXPORT_PLIST}${NC}"
echo -e "${GREEN}---------------------------${NC}"

if [[ "$DO_CLEAN" == "y" ]]; then
  $FLUTTER clean
fi

$FLUTTER pub get

# Only meaningful once the project takes on a codegen dependency.
if grep -q '^\s*build_runner:' pubspec.yaml; then
  $FLUTTER pub run build_runner build --delete-conflicting-outputs
fi

$FLUTTER build "$PLATFORM" --"$BUILD_MODE" \
  --dart-define-from-file="$ENV_SOURCE" \
  $EXPORT_PLIST

echo -e "${GREEN}------[ Completed build ]------${NC}"
