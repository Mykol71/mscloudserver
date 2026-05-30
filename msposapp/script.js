const steps = [
  {
    title: "Build OS media",
    copy:
      "Match the customer server patch level and prepare the POS image without relying on marketplace shortcuts.",
    state: "ready",
    os: "rocky9",
    container: "image build",
    vpn: "not required",
    backup: "standby",
    log: `$ create-image rocky9-rti
checking package set
installing POS dependencies
committing base image`,
  },
  {
    title: "Stage POS runtime",
    copy:
      "Install the Linux boot volume, run the RTI application setup, and commit the staged POS container.",
    state: "staging",
    os: "rocky9",
    container: "rti-pos-stage",
    vpn: "pending",
    backup: "standby",
    log: `$ stage-image --shop 12345678
mounting prepared volume
running application install
committing staged runtime`,
  },
  {
    title: "Restore production data",
    copy:
      "Pull the latest managed cloud backup into the staged runtime during the customer outage window.",
    state: "syncing",
    os: "rocky9",
    container: "rti-pos-prod",
    vpn: "pending",
    backup: "restoring",
    log: `$ restore_data --shop 12345678
source: tfrsync cloud backup
validating restored tables
ready for go-live check`,
  },
  {
    title: "Switch stores online",
    copy:
      "Start the POS container, bring VPNs online, and confirm branch traffic reaches the new cloud server.",
    state: "live",
    os: "rocky9",
    container: "running",
    vpn: "active",
    backup: "verified",
    log: `$ start_vpn && container_status
vpn tunnels: active
pos ip: 192.168.11.103
stores online`,
  },
];

const buttons = document.querySelectorAll(".step-button");
const title = document.querySelector("#workflow-step-title");
const copy = document.querySelector("#workflow-step-copy");
const state = document.querySelector("#workflow-step-state");
const os = document.querySelector("#workflow-os");
const container = document.querySelector("#workflow-container");
const vpn = document.querySelector("#workflow-vpn");
const backup = document.querySelector("#workflow-backup");
const log = document.querySelector("#workflow-log");

function selectStep(index) {
  const step = steps[index];

  buttons.forEach((button, buttonIndex) => {
    const isSelected = buttonIndex === index;
    button.classList.toggle("is-selected", isSelected);
    button.setAttribute("aria-selected", String(isSelected));
  });

  title.textContent = step.title;
  copy.textContent = step.copy;
  state.textContent = step.state;
  os.textContent = step.os;
  container.textContent = step.container;
  vpn.textContent = step.vpn;
  backup.textContent = step.backup;
  log.textContent = step.log;
}

buttons.forEach((button) => {
  button.addEventListener("click", () => {
    selectStep(Number(button.dataset.step));
  });
});

const scrollTarget = window.location.hash || new URLSearchParams(window.location.search).get("scroll");

if (scrollTarget) {
  window.addEventListener("load", () => {
    const targetSelector = scrollTarget.startsWith("#") ? scrollTarget : `#${scrollTarget}`;
    const target = document.querySelector(targetSelector);

    if (target) {
      target.scrollIntoView();
    }
  });
}
