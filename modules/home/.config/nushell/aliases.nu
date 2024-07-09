alias z = zoxide

alias vi  = lvim

alias k    = kubectl
alias kga  = kubectl get all
alias kp   = kubectl get pods
alias kgp  = kubectl get pods -o yaml
alias kdp  = kubectl describe pods
alias ks   = kubectl get service
alias kgs  = kubectl get service -o yaml
alias kgd  = kubectl get deployment
alias kgds = kubectl get daemonset
alias kdds = kubectl describe daemonset

def klog [namespace] {
  let namespace_flag = if $namespace != '' { '--namespace ' + $namespace } else { '' }
  let pod_name = (kubectl get pods $namespace_flag -o jsonpath="{.items[0].metadata.name}")
  kubectl logs $pod_name $namespace_flag
}

