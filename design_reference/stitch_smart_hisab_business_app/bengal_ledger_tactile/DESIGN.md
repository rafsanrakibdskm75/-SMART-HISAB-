---
name: Bengal Ledger Tactile
colors:
  surface: '#effdf3'
  surface-dim: '#cfddd4'
  surface-bright: '#effdf3'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e9f7ed'
  surface-container: '#e3f1e7'
  surface-container-high: '#ddece2'
  surface-container-highest: '#d8e6dc'
  on-surface: '#121e18'
  on-surface-variant: '#3f4943'
  inverse-surface: '#27332d'
  inverse-on-surface: '#e6f4ea'
  outline: '#6f7a73'
  outline-variant: '#bec9c1'
  surface-tint: '#176b4d'
  primary: '#005138'
  on-primary: '#ffffff'
  primary-container: '#176b4d'
  on-primary-container: '#9ae9c3'
  inverse-primary: '#89d6b1'
  secondary: '#006685'
  on-secondary: '#ffffff'
  secondary-container: '#91dbff'
  on-secondary-container: '#00617f'
  tertiary: '#753230'
  on-tertiary: '#ffffff'
  tertiary-container: '#924946'
  on-tertiary-container: '#ffcdca'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#a4f3cc'
  primary-fixed-dim: '#89d6b1'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#005138'
  secondary-fixed: '#bfe9ff'
  secondary-fixed-dim: '#86d0f3'
  on-secondary-fixed: '#001f2a'
  on-secondary-fixed-variant: '#004d65'
  tertiary-fixed: '#ffdad7'
  tertiary-fixed-dim: '#ffb3af'
  on-tertiary-fixed: '#3c0709'
  on-tertiary-fixed-variant: '#743230'
  background: '#effdf3'
  on-background: '#121e18'
  surface-variant: '#d8e6dc'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  currency-display:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Noto Sans
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 24px
  title-sm:
    fontFamily: Noto Sans
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
  body-lg:
    fontFamily: Noto Sans
    fontSize: 15px
    fontWeight: '400'
    lineHeight: 22px
  body-md:
    fontFamily: Noto Sans
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  body-sm:
    fontFamily: Noto Sans
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-md:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.03em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 12px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1rem
  margin-mobile: 0.875rem
  space-2xs: 0.125rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
  space-2xl: 2rem
---

## Brand & Style

This design system delivers a high-trust, tactile, and frictionless financial ledger experience engineered specifically for Bangladeshi SMEs, merchants, and modern professionals. The interface blends utilitarian financial clarity with premium material tactile depth—elevating traditional ledger bookkeeping (*টাকার হিসাব*) into a streamlined digital instrument.

### Design Aesthetics & Philosophy
- **Tactile Material Minimalism:** Grounded surfaces with subtle micro-borders, physical press states, and tactile edge highlights that feel authentic and responsive to touch.
- **Utilitarian Density:** High data density balanced with precise typographic hierarchy, preventing visual clutter while maintaining full visibility over complex cash flows, balances, and multi-channel MFS transactions.
- **Cultural Resonance:** Seamless coexistence of Bangla and English typographic structures, treating currency tokens (৳) and numerical ledgers as first-class display elements.
- **Absolute Trust & Clarity:** Clean whites and muted mineral backgrounds contrasted against deep forest emerald and decisive status tones (credit green, debit crimson).

## Colors

The palette is engineered for high legibility under direct outdoor sunlight and low-spec mobile displays, using deep vegetal greens paired with clinical banking neutrals.

### Provider & Operator Tokens
These specific color references must remain pure across all ledger items, chips, and payment method selectors:
- **MFS Providers:**
  - bKash: `#E2136E`
  - Nagad: `#F7941D`
  - Rocket: `#8C3494`
  - Upay: `#FFC423` (paired with `#17231D` foreground)
  - Bank Transfer: `#1E40AF`
- **Telecom Operators:**
  - Grameenphone: `#00A3E0`
  - Robi: `#ED1C24`
  - Banglalink: `#FF6600`
  - Airtel: `#E40000`
  - Teletalk: `#008D36`

### Functional Semantic Application
- **Income / Joma (জমা):** Use Success Green (`#16A36A`) with 8% tinted surface backgrounds (`#E8F7F0`).
- **Expense / Khoroch (খরচ):** Use Danger Crimson (`#DC4545`) with 8% tinted surface backgrounds (`#FCECEC`).
- **Due / Baki (বাকি):** Use Warning Amber (`#E7A23B`) for collection alerts and pending reconciliation.

## Typography

The type architecture pairs **Noto Sans Bengali** (for all native Bangla textual interfaces, customer names, notes, and instructions) with **Inter** (for numeric ledgers, transaction codes, phone numbers, and BDT metric cards).

### Implementation Rules
- **Bi-Script Harmony:** Ensure line-height calculations reserve adequate vertical breathing room for Bengali ascenders and descenders (য-ফলা, উ-কার) when stacked alongside numeric lines.
- **Tabular Figures:** All financial figures, balance values, and timestamps must render with fixed tabular figure widths (`font-variant-numeric: tabular-nums`) to preserve column alignment in ledger tables.
- **BDT Currency Symbol (৳):** Always match the font weight and optical baseline of the adjacent numeric value.

## Layout & Spacing

The layout structure optimizes for single-hand mobile usage on screens ranging from 360dp to 420dp width.

### Layout Model
- **Grid Architecture:** 4-column layout on mobile devices with `gutter-mobile` (12px) and canvas margin of 14px to maximize horizontal ledger density.
- **Vertical Rhythm:** 4px baseline module. Card padding strictly adheres to 12px (`space-md`) on condensed lists and 16px (`space-lg`) on primary balance cards.
- **Bottom Canvas Clearance:** Add a mandatory 88px clearance above bottom navigation bars to ensure floating action buttons never occlude balance summaries or transaction lists.

## Elevation & Depth

Visual hierarchy uses tactile card depth rather than floating blur effects, combining subtle hairline boundaries with warm ambient drop shadows.

### Elevation Levels
- **Level 0 (Flat/Base):** Canvas background `#F6F8F7`. No shadow.
- **Level 1 (Resting Cards & Ledger Rows):** `#FFFFFF` surface with a 1px solid `#E4EAE6` stroke and a soft drop shadow: `0px 1px 3px rgba(23, 35, 29, 0.04), 0px 1px 2px rgba(23, 35, 29, 0.02)`.
- **Level 2 (Active/Pressed/Hovered Cards):** `#FFFFFF` surface with shadow: `0px 4px 12px rgba(23, 35, 29, 0.06), 0px 1px 3px rgba(23, 35, 29, 0.04)`.
- **Level 3 (Modals, Overlays, & Floating Action Buttons):** Emerald `#176B4D` or Crisp White surface with shadow: `0px 8px 24px rgba(23, 107, 77, 0.22), 0px 2px 6px rgba(23, 35, 29, 0.08)`.

## Shapes

The design uses balanced, modern corner radii that enhance card separation without feeling excessively bubbly.

- **Base Elements:** `8px` (`0.5rem`) for standard text inputs, transaction list item groupings, and provider action tiles.
- **Cards & Sheets:** `16px` (`1rem`, `rounded-lg`) for primary balance cards, modal dialogs, and top summary modules.
- **Pill Elements:** Full circular pill radii (`9999px`) reserved strictly for search filter pills, status badges (সফল, অপেক্ষমাণ), and the center floating transaction action button.

## Components

### 1. BDT (৳) Currency Cards
- **Structure:** Surface White `#FFFFFF` or Emerald Forest `#176B4D` hero container with 16px padding.
- **Typography:** Net balance rendered in `headline-lg-mobile` with tabular Inter numbers.
- **Dual Flow Indicators:** Mini split grid beneath showing Total Cash In (সবুজ / Success Green) and Total Cash Out (লাল / Danger Crimson) with micro directional arrow badges (`↑` / `↓`).

### 2. Transaction Ledger Item Rows
- **Layout:** Horizontal 3-column row:
  - Left: 40px rounded avatar with MFS or transaction category icon.
  - Middle: Counterparty name (Noto Sans, 14px SemiBold) over timestamp & transaction channel (12px Muted).
  - Right: Net BDT amount aligned right, colored `#16A36A` with `+` prefix for Inflow, or `#DC4545` with `-` prefix for Outflow.
- **Divider:** Hairline border `#E4EAE6` inset by 56px to align cleanly with the text column.

### 3. Floating Action Button (+ লেনদেন)
- **Positioning:** Centered, docking onto or hovering 16px directly above the bottom navigation bar.
- **Style:** Emerald Forest `#176B4D` background, White `#FFFFFF` bold Bangla text and icon (`+ লেনদেন`), 48px height, pill radius, elevated with Level 3 emerald-tinted shadow.

### 4. MFS Provider & Operator Tiles
- **Form:** 64px x 64px rounded card (`rounded-md`, 8px).
- **Surface:** Provider identity background tint (10% opacity) with a solid 2px brand-color edge badge on selection.
- **Iconography:** Scaled vector logomark centered with micro brand text below in `label-sm`.

### 5. Search Filter Pills
- **State - Inactive:** `#FFFFFF` background, `#E4EAE6` border, `#17231D` secondary text.
- **State - Active:** `#176B4D` background, `#176B4D` border, `#FFFFFF` text.
- **Height:** 32px compact touch target, 12px horizontal padding, full pill roundedness.

### 6. Input Fields
- **Container:** `#FFFFFF` surface with 1px `#E4EAE6` border, 48px standard touch height, 12px horizontal padding.
- **Focus State:** 1.5px `#176B4D` stroke with 2px outer ring in `rgba(23, 107, 77, 0.12)`.
- **Currency Field Variant:** Prefix fixed with static `৳` symbol in Charcoal `#17231D` at 18px bold.