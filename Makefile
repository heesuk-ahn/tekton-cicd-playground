.PHONY: prep demo demo-multiserver demo-configfile demo-tilt demo-drone

onboard:
	./scripts/onboard.sh

tutorial2:
	./scripts/tutorial-2-tekton-ui.sh

tutorial3:
	./scripts/tutorial-3-pipeline.sh

tutorial4:
	./scripts/tutorial-4-triggers.sh