# Weatherly design system

Weatherly adapts a quiet, product-first visual language to a weather utility. Information is the product: typography, spacing, solid surfaces, and one blue action color do the work. It does not reproduce another weather application or use proprietary assets.

## Design read

- Mood: calm, precise, airy, useful.
- Density: moderate on phones, two-column information layout on tablets and web.
- Motion: restrained; only native route/state transitions and progress indicators.
- Primary surface rhythm: pale cloud canvas → dark atmospheric summary → white forecast sections.

## Tokens

| Role | Value |
|---|---|
| Action blue | `#006DAA` |
| Focus blue | `#0088D1` |
| Dark atmosphere | `#102A43` |
| Canvas | `#F4F7FA` |
| Card | `#FFFFFF` |
| Ink | `#17212B` |
| Muted ink | `#5D6B78` |
| Hairline | `#DDE5EC` |
| Warning | `#9A5B00` |

Structural spacing follows 8, 12, 16, 24, 32, and 48 logical pixels. Cards use an 18-pixel radius and hairline borders, without drop shadows. Search and primary actions use pill geometry. Minimum interactive target size is 48 pixels.

## Type

Use the platform sans-serif family. Temperature is the only oversized display value. Headings use weight 600; body uses 400; labels use 600. Numeric weather values use tabular figures where supported.

## Responsive behavior

- Under 760 px: single column, bottom navigation, horizontally scrolling hourly forecast.
- 760–959 px: centered content with two forecast columns where space permits.
- 960 px and above: navigation rail, maximum content width of 1120 px.
- Text scale and long translated city names must wrap without clipping.

## Components

- Weather summary: solid dark atmospheric tile with white text and no decorative gradient.
- Metric tile: white surface, thin border, icon + label + value.
- Forecast section: white surface with predictable row rhythm and clear headings.
- Search result: full-width semantic list tile showing city, region, and country.
- Empty/error state: icon, direct explanation, and one recovery action when available.

## Accessibility

All icon-only controls require tooltips and semantic labels. Status never relies on color alone. Loading regions expose a label, touch targets remain at least 48 px, and layouts tolerate 200% text scale.
