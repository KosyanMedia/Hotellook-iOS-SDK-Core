SCRIPT_DIR=`dirname $0`
PROTO_SRC_DIR="${SCRIPT_DIR}/../protos"
PROTO_VENDOR_SRC_DIR="${SCRIPT_DIR}/../protos_vendor"
OUTPUT_DIR="${SCRIPT_DIR}/../Sources/Generated"

PROTOs="location location_rpc common hotel hotel_rpc poi trustyou district search_rpc currency_rpc minprice complete_rpc airport review review_rpc"

for varproto in $PROTOs
do
    PROTO_FILES="$PROTO_FILES ${PROTO_SRC_DIR}/hl/api/${varproto}.proto"
done

mkdir -p $OUTPUT_DIR
protoc --swift_out=$OUTPUT_DIR\
        -I ${PROTO_VENDOR_SRC_DIR}\
       	-I $PROTO_SRC_DIR\
       	$PROTO_FILES

