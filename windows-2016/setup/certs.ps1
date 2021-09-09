$ErrorActionPreference = "Stop"

$webserver = "intranet.mdb-lab.com"
$url = "http://" + $webserver
$certRoot = "rootCA.crt"
$certIssuing = "issuingCA.crt"

# Verify connectivity
Test-Connection $webserver -Count 1

# Get certificates
ForEach ($cert in $certRoot,$certIssuing) {
  Invoke-WebRequest -Uri ($url + "/" + $cert) -OutFile C:\$cert
}

# Import Root CA certificate
Import-Certificate -FilePath C:\$certRoot -CertStoreLocation 'Cert:\LocalMachine\Root'

# Import Issuing CA certificate
Import-Certificate -FilePath C:\$certIssuing -CertStoreLocation 'Cert:\LocalMachine\CA'

# Delete certificates
ForEach ($cert in $certRoot,$certIssuing) {
  Remove-Item C:\$cert -Confirm:$false
}
