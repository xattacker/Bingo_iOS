SOURCE="${BASH_SOURCE[0]}"
DIR="$( dirname "$SOURCE" )"
while [ -h "$SOURCE" ]
do 
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
  DIR="$( cd -P "$( dirname "$SOURCE"  )" && pwd )"
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

cd "$DIR"

xcodebuild \
  -project Bingo.xcodeproj \
  -scheme Bingo \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 8,OS=14.4' \
  test \
  | xcbeautify
