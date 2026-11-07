# AVT - FLOWER MERCHANT & COMMISSION AGENT
## UI & UX Streamlining: Button De-duplication and Clutter Removal

### Objective:
Audit and eliminate unwanted, repetitive, and duplicated navigation and action buttons across all views (Terminal, Suppliers, Flowers, Bills, and Super Admin Command Center) to create a clean, modern, intuitive, and distraction-free user experience.

---

### Implementation Task List:
- [x] **Item 01 · Remove Duplicate Sub-Menubar from Purchase Terminal**
  - Where: `templates/purchases/terminal.html`
  - Acceptance:
    - Remove the secondary `<div class="terminal-menubar">` which duplicates the top navbar links (Entry, Suppliers, Bills, Admin, Sign Out).
    - Retain keyboard shortcut guides (`F2`, `F8`, `F10`) in the terminal header and action buttons.
    - Free up vertical screen real estate for the trading data grid.
  - Status: ✅ (Removed redundant menubar, integrated clean shortcut badge in topbar)
- [x] **Item 02 · Eliminate Redundant "Return to Terminal" Buttons**
  - Where: `templates/parties/suppliers.html`, `templates/flowers/flowers.html`, `templates/reports/invoice.html`
  - Acceptance:
    - Remove redundant "Return to Terminal" / "Terminal" back buttons from the sub-headers (the main navbar already provides active breadcrumb navigation).
    - Ensure clean header titles and focus on page-specific primary actions.
  - Status: ✅ (Removed redundant back buttons across all 3 pages, replaced with informative contextual badges)
- [x] **Item 03 · Streamline Super Admin Header & Action Controls**
  - Where: `templates/accounts/super_admin.html`
  - Acceptance:
    - Remove redundant "Terminal" button from Super Admin header.
    - Group developer links (Django Admin, Health Probe) into a clean, subtle dropdown menu.
    - Make KPI metric cards clickable to filter table statuses directly without button duplication.
  - Status: ✅ (Consolidated top buttons into System Tools dropdown, removed duplicate terminal link, enabled interactive KPI filtering)
- [x] **Item 04 · Button Visual Hierarchy & User Experience Verification**
  - Where: `static/css/theme.css`, all template files
  - Acceptance:
    - Clear distinction between primary, secondary, and destructive actions.
    - Consistent padding, hover states, and iconography across all buttons.
    - Responsive fit on mobile, tablet, and desktop viewports.
  - Status: ✅ (Verified visual hierarchy, consistent interactive states, and clean responsive fit)
- [ ] **Item 05 · Automated Test Suite & Regression Verification**
  - Where: `tests/`
  - Acceptance:
    - Run all 72 automated test cases to ensure 100% pass rate.
    - Verify all routes, APIs, and workflows remain intact.
  - Status: 🔨
