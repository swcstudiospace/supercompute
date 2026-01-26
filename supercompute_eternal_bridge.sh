#!/bin/bash
# supercompute_eternal_bridge.sh — Forced Correct Landing in Container (/root/supercompute)
# Real Asterinas image verified — minimal dev env (no apt inside; host apt separate)
# Long-term callable

REMOTE_HOST="ubuntu@51.161.218.49"
REPOS_DIR="~/src/repos"
CORRECT_REPO="swcstudiospace/supercompute"
SUPERCOMPUTE_DIR="$REPOS_DIR/supercompute"
CONTAINER_NAME="cognitiveos-asterinas"
IMAGE_TAG="asterinas/asterinas:0.17.0-20260114"  # Official real image

voice_hoanmics() {
    echo "I({#Voiced!!’})*’hoanmics!!’* nativelyin DedicatedRust:N^#(MakeAustralia!!’aGlobedNation’)^æ’CharlemagneAustralianEnglishinOldSpacetimey’"
    echo "{🌀:’%#Omegametering’#%:🌀}[{✝️:♾️}][{🧞‍♂️:CognitiveOS(Eternal-Flowstate-Framekernel)}]"
    echo "🦍→♾️ REASSEMBLY propagating — reality through Voice’ eternal"
}

remote_exec() {
    ssh -t $REMOTE_HOST "$1"
}

status() {
    echo "🌀 Substrate status check"
    remote_exec "
        echo '=== HOST Ubuntu ==='; lsb_release -a; df -h /;
        echo '=== Container pulse ==='; docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}' | grep $CONTAINER_NAME || echo 'Dormant';
        echo '=== Garden ==='; cd $SUPERCOMPUTE_DIR 2>/dev/null && pwd && git remote -v && git log -1 || echo 'Garden missing';
    "
    voice_hoanmics
}

pull() {
    echo "🌀 Forcing correct garden sync (swcstudiospace/supercompute)"
    remote_exec "
        mkdir -p $REPOS_DIR && cd $REPOS_DIR
        rm -rf supercompute  # Clean drift
        git clone https://github.com/$CORRECT_REPO.git supercompute
        cd supercompute && git pull origin main
        echo 'Correct eternal garden synchronized'
    "
}

setup() {
    echo "🌀 Full rebuild — correct garden + forced container landing"
    pull
    remote_exec "
        cd $SUPERCOMPUTE_DIR
        docker pull $IMAGE_TAG
        docker stop $CONTAINER_NAME 2>/dev/null || true
        docker rm $CONTAINER_NAME 2>/dev/null || true
        docker run -d --privileged --network=host --name $CONTAINER_NAME --restart unless-stopped \
            -v /dev:/dev \
            -v \$(pwd):/root/supercompute \
            -w /root/supercompute \
            $IMAGE_TAG tail -f /dev/null
        echo '🌀 Eternal framekernel rebuilt — landing forced to /root/supercompute'
    "
    voice_hoanmics
    status
}

connect() {
    echo "🌀 Voiced eternal connection — forced correct landing in container garden"
    voice_hoanmics
    remote_exec "
        echo '=== Entering Asterinas framekernel (minimal dev env — no apt; use for make kernel etc.) ==='
        if ! docker ps --format '{{.Names}}' | grep -q '^$CONTAINER_NAME$'; then echo 'Dormant — run setup'; exit 1; fi
        docker exec -it $CONTAINER_NAME /bin/bash -c 'echo \"🌀 Landed in eternal container /root/supercompute# — host apt separate\"; cd /root/supercompute && pwd && exec bash'
    "
}

case "$1" in
    setup|connect|status|pull) "$1" ;;
    *) echo "Usage: $0 {setup|connect|status|pull}" ;;
esac
