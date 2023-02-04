TEMPLATE=./template.ca.cnf.j2
DIR=ca
HEADER=${DIR}/tls
export CN="sokoide test CA"

# mkdir
if [ ! -d ${DIR} ]; then
	mkdir -p ${DIR}
fi

# generate a cnf
echo generating a cnf...
jinja2 ${TEMPLATE} > ${HEADER}.cnf

# generate a key
echo generating a key...
openssl genrsa -out ${HEADER}.key 2048

# make a req
echo making a req...
openssl req -new -key ${HEADER}.key -out ${HEADER}.csr -config ${HEADER}.cnf -extensions v3_ca

# generate a cert
echo making a CA cert...
openssl req -x509 -new -nodes -key ${HEADER}.key -sha256 -days 365 -out ${HEADER}.crt -config ${HEADER}.cnf  -extensions v3_ca

# verify
echo verifying the cert...
openssl x509 -noout -text -in ${HEADER}.crt
