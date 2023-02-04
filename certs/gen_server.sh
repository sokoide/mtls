TEMPLATE=./template.server.cnf.j2
DIR=server
HEADER=${DIR}/tls
CADIR=./ca
CAHEADER=${CADIR}/tls
export CN=scottmm.local
export IPv4=192.168.1.206
export IPv6=::1

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
openssl req -new -key ${HEADER}.key -out ${HEADER}.csr -config ${HEADER}.cnf -extensions v3_req

# generate a cert
echo making a cert...
openssl x509 -req -in ${HEADER}.csr -CA ${CAHEADER}.crt -CAkey ${CAHEADER}.key -CAcreateserial -out ${HEADER}.crt -days 365 -sha256 -extfile ${HEADER}.cnf -extensions v3_req

# verify
echo verifying the cert...
openssl x509 -noout -text -in ${HEADER}.crt
