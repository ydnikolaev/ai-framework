# ═══════════════════════════════════════════════════════════════
# 🎨 DX Makefile Utilities
# Based on AI-Framework — https://github.com/ydnikolaev/ai-framework
# ═══════════════════════════════════════════════════════════════
# Include this in your Makefile:
#   include ai-framework/templates/make/dx.mk

# Colors
RESET   := \033[0m
BOLD    := \033[1m
DIM     := \033[2m
RED     := \033[31m
GREEN   := \033[32m
YELLOW  := \033[33m
BLUE    := \033[34m
MAGENTA := \033[35m
CYAN    := \033[36m

# Log functions
define log_info
	@printf "$(CYAN)$(BOLD)→$(RESET) $(1)\n"
endef

define log_success
	@printf "$(GREEN)$(BOLD)✓$(RESET) $(1)\n"
endef

define log_warning
	@printf "$(YELLOW)$(BOLD)⚠$(RESET) $(1)\n"
endef

define log_error
	@printf "$(RED)$(BOLD)✗$(RESET) $(1)\n"
endef

define log_header
	@printf "\n$(MAGENTA)$(BOLD)═══════════════════════════════════════$(RESET)\n"
	@printf "$(MAGENTA)$(BOLD)  $(1)$(RESET)\n"
	@printf "$(MAGENTA)$(BOLD)═══════════════════════════════════════$(RESET)\n\n"
endef

define log_step
	@printf "$(DIM)▸ [$(1)/$(2)]$(RESET) $(3)\n"
endef

define log_box
	@printf "\n$(CYAN)╔═══════════════════════════════════════╗$(RESET)\n"
	@printf "$(CYAN)║$(RESET)  $(BOLD)$(1)$(RESET)\n"
	@printf "$(CYAN)╚═══════════════════════════════════════╝$(RESET)\n\n"
endef

define log_dim
	@printf "$(DIM)   $(1)$(RESET)\n"
endef

# Helper for showing links
define log_link
	@printf "$(DIM)   $(1): $(RESET)$(CYAN)$(2)$(RESET)\n"
endef
