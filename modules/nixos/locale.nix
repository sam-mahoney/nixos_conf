{ config, pkgs, ... }:

{
  # === Time Zone ===
  # System clock timezone for London, UK
  time.timeZone = "Europe/London";

  # === Locale Settings ===
  # Primary locale for the system (language, number formats, etc.)
  i18n.defaultLocale = "en_GB.UTF-8";

  # === Additional Locale Settings ===
  # Granular control over specific locale categories
  # All set to British English standards
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";         # Address formatting
    LC_IDENTIFICATION = "en_GB.UTF-8";  # System identification
    LC_MEASUREMENT = "en_GB.UTF-8";     # Metric system
    LC_MONETARY = "en_GB.UTF-8";        # Currency (GBP)
    LC_NAME = "en_GB.UTF-8";            # Name formatting
    LC_NUMERIC = "en_GB.UTF-8";         # Number formatting
    LC_PAPER = "en_GB.UTF-8";           # Paper sizes (A4)
    LC_TELEPHONE = "en_GB.UTF-8";       # Phone number formatting
    LC_TIME = "en_GB.UTF-8";            # Date and time formatting
  };
}
