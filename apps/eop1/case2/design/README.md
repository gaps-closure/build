Design procedure to be converted into CVI tasks

mkdir ../xdcc/egress_xdcc/xdcc_autogen
mkdir ../xdcc/ingress_xdcc/xdcc_autogen
mkdir ../xdcc/xdcc_echo
# $HOME/gaps/build/apps/eop1/case2/design

cat << EOT > config.json
{
    "egressDir": "../xdcc/egress_xdcc/xdcc_autogen",
    "ingressDir": "../xdcc/ingress_xdcc/xdcc_autogen",
    "echoDir": "../xdcc/xdcc_echo",
    "enclave": "orange",
    "xdccFlow": "design_spec.json"
}
EOT

/opt/closure/bin/xdcc_gen -c config.json