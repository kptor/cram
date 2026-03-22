# Frontend Design Guidelines

Inspired by [Notion's design philosophy](https://recordings.designmatters.io/talks/notions-design-process-and-principles/) and [Refactoring UI](https://refactoringui.com/) by Adam Wathan & Steve Schoger.

## Core Principles

**Content first.** The interface should disappear. Minimize chrome, decoration, and visual noise. If it doesn't serve the content, remove it.

**Hierarchy through spacing, typography, and colour — not borders.** Use font size, weight, and colour to establish importance. Use background shades and subtle fills to distinguish sections and surface layers — without borders, different shades do the heavy lifting. Use whitespace to group and separate. Borders are a last resort.

**Fewer outlines, fewer borders.** Don't outline inputs, cards, or sections by default. Use subtle background fills or shadows instead. When a border is truly needed, keep it light (`border` token, not a hard color).

**Monochromatic by default.** Keep the palette neutral. Use color sparingly and intentionally — for status, emphasis, or interactive elements. Design in grayscale first, then add color only where it earns its place.

## Typography

- Establish hierarchy with **weight and color**, not just size
- Two levels of text color: `foreground` for primary, `muted-foreground` for secondary
- Never use grey text on colored backgrounds — adjust hue instead to maintain contrast

## Spacing

- Use the Tailwind spacing scale consistently — don't invent arbitrary values
- Start with more space than you think you need, then tighten
- Group related elements with tight spacing; separate sections with generous spacing

## Components

- Keep components visually quiet until interacted with
- Progressive disclosure — hide complexity until the user needs it
- Hover/focus states should feel subtle, not dramatic
- Use shadows for elevation (dropdowns, modals), not borders

## Don'ts

- Don't add outlines to everything
- Don't use color for decoration
- Don't make every element compete for attention
- Don't add borders between list items when spacing alone is sufficient
- Don't reach for a border when whitespace or a background shift would work
