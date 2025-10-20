# Color Correction Studio - UI Architecture Documentation

**Version:** 4.0.0  
**Date:** October 15, 2025  
**Purpose:** Complete guide for recreating the UI in another language/framework

---

## Table of Contents
1. [Overview](#overview)
2. [Visual Design System](#visual-design-system)
3. [Layout Structure](#layout-structure)
4. [Component Hierarchy](#component-hierarchy)
5. [State Management](#state-management)
6. [User Interactions & Functions](#user-interactions--functions)
7. [API Integration](#api-integration)
8. [Modals & Dialogs](#modals--dialogs)
9. [Responsive Design Breakpoints](#responsive-design-breakpoints)
10. [Animation & Transitions](#animation--transitions)

---

## 1. Overview

### Application Type
- **Single Page Application (SPA)**
- **Layout:** Fixed header + two-column grid (left sidebar + main content)
- **Theme:** Dark background with light content cards
- **Style:** Modern glassmorphism with gradients

### Technology Stack (Reference)
- **Frontend Framework:** React 18.3.1
- **Styling:** Tailwind CSS (utility-first)
- **Build Tool:** Vite
- **State:** React Hooks (useState, useRef, useCallback, useMemo, memo)

---

## 2. Visual Design System

### Color Palette

#### Background
- **Main Background:** Gradient from `gray-950` → `indigo-950` → `gray-950`
- **Purpose:** Creates depth and professional appearance

#### Primary Colors
- **Blue-Indigo:** Used for file management and primary actions
  - Light: `blue-50` to `indigo-50`
  - Medium: `blue-500` to `indigo-600`
  - Dark: `blue-600` to `indigo-700`

- **Green-Emerald-Teal:** Used for corrections and success states
  - Light: `green-50` to `teal-50`
  - Medium: `green-500` to `teal-600`
  - Dark: `green-600` to `teal-700`

- **Cyan-Blue:** Used for secondary actions
  - Range: `cyan-500` to `blue-600`

- **Purple-Pink:** Used for special features (CCM files)
  - Range: `purple-500` to `pink-600`

- **Amber-Orange:** Used for detection and warnings
  - Range: `amber-500` to `orange-600`

- **Red-Rose:** Used for destructive actions and system controls
  - Range: `red-600` to `rose-700`

#### Text Colors
- **Primary Text:** `gray-800` to `gray-900`
- **Secondary Text:** `gray-600` to `gray-700`
- **Muted Text:** `gray-400` to `gray-500`
- **Success Text:** `green-700`
- **Error Text:** `red-600`
- **Link/Accent Text:** `indigo-600`

#### Terminal/Log Colors
- **Background:** `gray-900` with gradient to `gray-800`
- **Text:** `green-400` (terminal-style)
- **Muted:** `gray-500`

### Typography

#### Font Families
- **Body:** System fonts (default sans-serif)
- **Monospace:** For activity log (terminal-style)

#### Font Sizes (Responsive)
- **Main Title:** 
  - Mobile: `text-2xl` (1.5rem)
  - Tablet: `text-3xl` (1.875rem)
  - Desktop: `text-4xl` (2.25rem)

- **Section Headers:**
  - Mobile: `text-xs` to `text-sm`
  - Tablet: `text-sm` to `text-base`
  - Desktop: `text-base` to `text-xl`

- **Body Text:** `text-xs` to `text-sm`
- **Button Text:** `text-xs` to `text-base`

#### Font Weights
- **Bold:** Section headers, buttons (`font-bold`)
- **Semibold:** Sub-headers, labels (`font-semibold`)
- **Medium:** Body text in emphasized areas (`font-medium`)
- **Normal:** Default text

### Spacing & Sizing

#### Border Radius
- **Extra Small:** `rounded` (0.25rem)
- **Small:** `rounded-lg` (0.5rem)
- **Medium:** `rounded-xl` (0.75rem)
- **Large:** `rounded-2xl` (1rem)

#### Padding
- **Compact:** `p-2` to `p-3` (0.5rem - 0.75rem)
- **Normal:** `p-3` to `p-4` (0.75rem - 1rem)
- **Spacious:** `p-4` to `p-6` (1rem - 1.5rem)

#### Gaps
- **Tight:** `gap-2` (0.5rem)
- **Normal:** `gap-3` to `gap-4` (0.75rem - 1rem)
- **Wide:** `gap-6` to `gap-8` (1.5rem - 2rem)

### Shadows & Effects

#### Shadow Hierarchy
- **Small:** `shadow-sm` - Subtle elevation
- **Medium:** `shadow-md` to `shadow-lg` - Standard cards
- **Large:** `shadow-xl` to `shadow-2xl` - Modals, important cards
- **Inner:** `shadow-inner` - Inset effects for inputs

#### Glassmorphism
- **Backdrop Blur:** `backdrop-blur-sm` to `backdrop-blur-xl`
- **Opacity:** `bg-white/10` to `bg-white/95`
- **Border:** `border-white/20` to `border-white/50`

#### Gradients
- **Direction:** `bg-gradient-to-r`, `bg-gradient-to-br`
- **Text Gradients:** `bg-clip-text text-transparent`
- **Multi-stop:** Use `via-` for three-color gradients

---

## 3. Layout Structure

### Page Container
```
┌─────────────────────────────────────────────────────────┐
│ Root Container (Full Screen)                            │
│ - Min height: 100vh                                     │
│ - Background: Dark gradient                             │
│ - Padding: Responsive (p-2 to p-8)                      │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ Header (Glassmorphism)                             │ │
│  │ - Max width: 1600px                                │ │
│  │ - Centered                                          │ │
│  │ - Contains: Title + Subtitle                       │ │
│  └────────────────────────────────────────────────────┘ │
│                                                          │
│  ┌────────────────────────────────────────────────────┐ │
│  │ Main Content Card                                  │ │
│  │ - Max width: 1600px                                │ │
│  │ - Centered                                          │ │
│  │ - Background: Light with gradient                  │ │
│  │                                                      │ │
│  │  ┌──────────────┬─────────────────────────────────┐│ │
│  │  │              │                                  ││ │
│  │  │  Left Panel  │     Right Panel                 ││ │
│  │  │  (3 cols)    │     (9 cols on desktop)         ││ │
│  │  │              │                                  ││ │
│  │  │  Controls    │     Image Preview               ││ │
│  │  │  & Logs      │                                  ││ │
│  │  │              │                                  ││ │
│  │  └──────────────┴─────────────────────────────────┘│ │
│  └────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

### Grid System
- **Desktop (lg+):** 12-column grid
  - Left sidebar: 3 columns
  - Right content: 9 columns
- **Tablet/Mobile:** Stack vertically (1 column)

---

## 4. Component Hierarchy

### 4.1 Header Component

**Location:** Top of page  
**Type:** Fixed position header

```
Header
├─ Icon (🎨 emoji, size: 3xl-5xl)
├─ Title (Text with gradient)
│  └─ "Color Correction Studio"
└─ Subtitle (Gray text)
   └─ "Custom image color correction powered by advanced algorithms"
```

**Styling:**
- Background: `bg-white/10` with `backdrop-blur-md`
- Border: `border-white/20`
- Padding: `p-4` to `p-6`
- Shadow: `shadow-2xl`
- Radius: `rounded-2xl`

---

### 4.2 Left Sidebar (Control Panel)

**Layout:** Vertical stack with spacing  
**Sections:** 8 main sections (some collapsible)

#### Section 1: File Management
**State:** Always visible  
**Background:** Blue-Indigo gradient

**Components:**
1. **Load Images Button**
   - Icon: 📸
   - Gradient: blue-500 → indigo-600
   - Action: Opens file picker (multiple images)
   - Accept: image/*

2. **White Image Button**
   - Icon: 🟦
   - Gradient: cyan-500 → blue-600
   - Action: Opens file picker (single image)
   - Purpose: For Flat Field Correction

3. **CCM File Button**
   - Icon: 📊
   - Gradient: purple-500 → pink-600
   - Action: Opens file picker
   - Accept: .csv, .txt, .json

4. **Detect Chart Button**
   - Icon: 🔍
   - Gradient: amber-500 → orange-600
   - State: Disabled if no images loaded
   - Action: Detects color chart in selected image

5. **Clear All Button** (Conditional)
   - Icon: 🗑️
   - Appearance: White with border
   - Visibility: Only shown when images.length > 0
   - Text: Shows count "(X)"
   - Action: Clears all loaded images

---

#### Section 2: Correction Settings
**State:** Collapsible (default: collapsed)  
**Background:** Green-Emerald-Teal gradient

**Header:**
- Icon: ⚙️
- Title: "Corrections"
- Toggle button (▶/▼)

**Content (when expanded):**
Four correction toggles with settings buttons:

1. **FFC (Flat Field Correction)**
   - Checkbox (enabled by default)
   - Settings button → Opens modal

2. **GC (Gamma Correction)**
   - Checkbox (enabled by default)
   - Settings button → Opens modal

3. **WB (White Balance)**
   - Checkbox (enabled by default)
   - Settings button → Opens modal

4. **CC (Color Correction)**
   - Checkbox (enabled by default)
   - Settings button → Opens modal

**Additional Options:**
- Checkbox: "Show result dialogs after correction"
- Checkbox: "Compute ΔE metrics (single image only)"
  - Helper text: "💡 Disable for faster processing"

**Each Toggle Row:**
- Background: White
- Border: gray-200
- Padding: p-2
- Radius: rounded-lg
- Layout: Checkbox + Label | Settings Button

---

#### Section 3: Primary Action
**State:** Always visible  
**Background:** Green gradient with special effects

**Component:**
- **Run Correction Button**
  - Icon: ▶️ (or animated spinner when running)
  - Size: Large (py-3 to py-4)
  - Gradient: green-500 → emerald-600 → teal-600
  - States:
    - Normal: Full gradient, shadow, pulse effect
    - Running: Gray background, spinner icon
    - Disabled: Gray, no hover effects
  - Animation: Pulse when ready, scale on click

**Styling Notes:**
- Most prominent button in the UI
- Uses `animate-pulse-slow` class when idle
- Active state: `scale-95` (pressed effect)

---

#### Section 4: Batch Operations
**State:** Collapsible (default: collapsed)  
**Background:** Orange-Red gradient

**Header:**
- Icon: ⚡
- Title: "Batch Ops"

**Content:**
1. **Apply to Others Button**
   - Icon: 🎨
   - Gradient: cyan-500 → teal-600
   - Action: Opens dialog to select images for batch correction
   - Disabled: When no images or running

2. **Process All Button**
   - Icon: ⚡
   - Gradient: orange-500 → red-600
   - Action: Processes all loaded images in parallel
   - Disabled: When no images or running

---

#### Section 5: Results & Analysis
**State:** Collapsible (default: collapsed)  
**Background:** Amber-Yellow gradient

**Header:**
- Icon: 📊
- Title: "Analysis"

**Content:**
Four analysis buttons (disabled until data available):

1. **Difference Button**
   - Icon: 🔬
   - Shows: Pixel-wise difference between original and corrected
   - Enabled when: comparisonData.difference exists

2. **Before/After Button**
   - Icon: 📷
   - Shows: Side-by-side comparison
   - Enabled when: both original and corrected exist

3. **RGB Scatter Button**
   - Icon: 📈
   - Shows: 3D scatter plot of RGB values
   - Enabled when: scatterPlotData exists

4. **ΔE Metrics Button**
   - Icon: 📊
   - Shows: Delta E color difference metrics
   - Enabled when: deltaEValues has data

**Button Style:**
- Background: White
- Border: Colored (matches function)
- Text: Colored
- State: Gray when disabled

---

#### Section 6: Data Management
**State:** Collapsible (default: collapsed)  
**Background:** Indigo-Purple gradient

**Header:**
- Icon: 💾
- Title: "Data"

**Content:**
1. **Save Button**
   - Icon: 💾
   - Gradient: indigo-500 → blue-600
   - Action: Opens save dialog for corrected images

2. **Models Button**
   - Icon: 📦
   - Gradient: violet-500 → purple-600
   - Action: Opens model management dialog

---

#### Section 7: System Controls
**State:** Collapsible (default: collapsed)  
**Background:** Rose-Red gradient

**Header:**
- Icon: 🔧
- Title: "System"

**Content:**
1. **Restart Button**
   - Icon: 🔄
   - Style: White background with rose border
   - Action: Restarts backend server
   - Disabled: When processing

2. **Exit Button**
   - Icon: 🚪
   - Gradient: red-600 → red-700
   - Style: Bold
   - Action: Closes application
   - Disabled: When processing

---

#### Section 8: Batch Progress Indicator
**State:** Conditional (visible during batch processing)  
**Background:** Blue-Indigo gradient

**Components:**
1. **Progress Text**
   - Format: "Batch Progress: X/Y"
   - Percentage badge (rounded pill)

2. **Progress Bar**
   - Container: Blue-200 background
   - Fill: Blue-500 → Indigo-600 gradient
   - Height: 3-4 units
   - Animation: Shimmer effect on fill

3. **Status Text**
   - Shows current operation
   - Background: White/50 opacity
   - Padding: Small, rounded

**Data Structure:**
```javascript
batchProgress = {
  current: number,  // Images processed
  total: number,    // Total images
  status: string    // Current operation description
}
```

---

#### Section 9: Activity Log
**State:** Always visible  
**Background:** Dark (terminal style)

**Header:**
- Icon: 📋
- Title: "Activity Log"
- Text gradient: green-400 → emerald-400

**Log Container:**
- Background: Black/30 opacity
- Text: Green-400 (terminal style)
- Font: Monospace
- Height: Fixed (36-44 units responsive)
- Scrolling: Auto-scroll to bottom
- Empty state: "Ready to process images..." (italic, gray)

**Styling:**
- Border: gray-700
- Inner padding: p-3
- Scrollbar: Custom styled (thin, gray)

---

### 4.3 Right Panel (Image Preview)

**Layout:** Single column, full height  
**Background:** Gray-50 via white gradient

#### Header Section

**Components:**
1. **Title**
   - Icon: 🖼️ (2xl-3xl)
   - Text: "Image Preview"
   - Style: Gradient text (gray-800 → gray-600)

2. **Preview Label** (conditional)
   - Shows current image type (e.g., "Original Image", "Corrected")
   - Background: Indigo-50
   - Text: Indigo-600
   - Style: Inline badge

3. **Chart Detection Badge** (conditional)
   - Text: "✓ Chart Detected"
   - Background: Gradient (green-100 → emerald-100)
   - Border: green-400
   - Position: Top-right corner
   - Size: Bold, small-medium

---

#### Content Section

**State 1: No Images Loaded**
- **Empty State**
  - Icon: 📷 (very large, 6xl-9xl)
  - Title: "No images loaded"
  - Subtitle: "Click 'Load Images' to get started"
  - Tip box: "💡 Tip: You can load multiple images..."
  - Background: Dashed border, gray-300
  - Height: Full height of panel

**State 2: Images Loaded**

1. **Main Image Display**
   - Container: White → gray-50 gradient
   - Border: gray-200 (2px)
   - Padding: p-3 to p-4
   - Shadow: shadow-lg
   - Radius: rounded-xl
   
   - **Image:**
     - Max height: Responsive (250px - 550px)
     - Width: 100%
     - Object-fit: contain
     - Alignment: Center
     - Shadow: shadow-xl
     - Radius: rounded-lg

2. **Image Gallery** (conditional, shown if images.length > 1)
   - Container background: White/50 with backdrop-blur
   - Border: gray-200
   - Radius: rounded-xl
   - Padding: p-3
   
   - **Gallery Header:**
     - Text: "Image Gallery (X)"
     - Size: Extra small
     - Weight: Semibold
     - Color: Gray-600
     - Transform: Uppercase, tracking-wide
   
   - **Thumbnail Strip:**
     - Layout: Horizontal scroll
     - Gap: 3 units
     - Scrollbar: Custom (indigo-400 thumb)
   
   - **Each Thumbnail:**
     - Size: 14-20 units (responsive)
     - Shape: Rounded-xl
     - Border: 2-4px
     - Cursor: Pointer
     - Transition: All properties
     
     - **States:**
       - Unselected: gray-300 border, 70% opacity
       - Selected: indigo-600 border (4px), ring-2 ring-indigo-300, full opacity
       - Hover: scale-110, shadow-lg, full opacity

---

## 5. State Management

### State Variables (43 total)

#### Core Application State
```javascript
images: Array<{file: File, url: string}>
  - All loaded images with object URLs
  
whiteImage: {file: File, url: string} | null
  - White reference image for FFC
  
ccmFile: File | null
  - Color correction matrix file
  
selectedImage: string | null
  - URL of currently previewed image
  
running: boolean
  - True when processing is active
  
chartDetected: boolean
  - True if color chart detected in current image
  
previewLabel: string
  - Describes current preview ("Original", "Corrected", etc.)
```

#### Correction Settings
```javascript
ffcEnabled: boolean (default: true)
gcEnabled: boolean (default: true)
wbEnabled: boolean (default: true)
ccEnabled: boolean (default: true)
saveCcModel: boolean (default: false)
computeDeltaE: boolean (default: true)
method: string (default: "pls")
```

#### Modal/Dialog States (12 modals)
```javascript
ffcModalOpen: boolean
gcModalOpen: boolean
wbModalOpen: boolean
ccModalOpen: boolean
modelModalOpen: boolean
saveDialogOpen: boolean
deltaEDialogOpen: boolean
applyDialogOpen: boolean
processAllDialogOpen: boolean
differenceDialogOpen: boolean
beforeAfterDialogOpen: boolean
scatterDialogOpen: boolean
saveStepsDialogOpen: boolean
```

#### Collapsible Section States
```javascript
correctionsExpanded: boolean (default: false)
batchOpsExpanded: boolean (default: false)
analysisExpanded: boolean (default: false)
dataExpanded: boolean (default: false)
systemExpanded: boolean (default: false)
```

#### Processing Results
```javascript
availableImages: Array<string>
  - URLs of processed images
  
deltaEValues: Object<string, number>
  - Delta E metrics by correction type
  
comparisonData: {
  original: string | null,
  corrected: string | null,
  difference: string | null
}
  - URLs for comparison views
  
scatterPlotData: any | null
  - RGB scatter plot data
```

#### Batch Processing
```javascript
batchProgress: {
  current: number,
  total: number,
  status: string
}

selectedForApply: Array<number>
  - Indices of images selected for batch apply
  
selectedForSave: Array<string>
  - Image types selected for saving
  
batchImagesList: Array<any>
  - List of batch processed images
  
numThreads: number (default: 2)
  - Thread count for parallel processing
```

#### Save Operations
```javascript
saveDirectory: string
modelSaveFolder: string
selectedStepsToSave: Array<string> (default: ['CC'])
selectedImagesToSave: Array<number>
```

#### Settings Objects

**FFC Settings:**
```javascript
{
  manual_crop: boolean (false),
  bins: number (50),
  smooth_window: number (5),
  degree: number (3),
  fit_method: string ('pls'),
  interactions: boolean (true),
  max_iter: number (1000),
  tol: number (1e-8),
  verbose: boolean (false),
  random_seed: number (0)
}
```

**GC Settings:**
```javascript
{
  max_degree: number (5)
}
```

**CC Settings:**
```javascript
{
  cc_method: string ('ours'),
  method: string ('Finlayson 2015'),
  mtd: string ('pls'),
  degree: number (2),
  max_iterations: number (10000),
  random_state: number (0),
  tol: number (1e-8),
  verbose: boolean (false),
  n_samples: number (50),
  // PLS-specific
  ncomp: number (1),
  // NN-specific
  nlayers: number (100),
  hidden_layers: Array<number> ([64, 32, 16]),
  learning_rate: number (0.001),
  batch_size: number (16),
  patience: number (10),
  dropout_rate: number (0.2),
  optim_type: string ('adam'),
  use_batch_norm: boolean (true)
}
```

#### Logs & Performance
```javascript
logs: string
  - Accumulated log text
  
logsBufferRef: Ref<Array<string>>
  - Buffer for batched log updates
  
logsFlushTimerRef: Ref<number>
  - Timer for flushing logs
```

#### UI Preferences
```javascript
showDialogsAfterCC: boolean (default: true)
  - Whether to auto-show result dialogs after correction
```

---

## 6. User Interactions & Functions

### 6.1 File Upload Functions

#### handleLoadImages(event)
**Trigger:** Click on "Load Images" button  
**Purpose:** Upload one or more images

**Flow:**
1. User clicks button → triggers file input
2. User selects images (multiple allowed)
3. Create object URLs for preview
4. Add to images array
5. Upload to backend via `/api/upload-images` (POST)
6. Set first image as selected if none selected
7. Log success/failure

**Backend API:**
- Endpoint: `http://localhost:5000/api/upload-images`
- Method: POST
- Body: FormData with 'images' field (multiple files)
- Response: `{message: string}`

---

#### handleLoadWhiteImage(event)
**Trigger:** Click on "White Image" button  
**Purpose:** Upload white reference image for FFC

**Flow:**
1. User clicks button → triggers file input
2. User selects single image
3. Create object URL
4. Set whiteImage state
5. Upload to backend via `/api/upload-white-image` (POST)
6. Log success/failure

**Backend API:**
- Endpoint: `http://localhost:5000/api/upload-white-image`
- Method: POST
- Body: FormData with 'white_image' field (single file)
- Response: `{message: string}`

---

#### handleLoadCCM(event)
**Trigger:** Click on "CCM File" button  
**Purpose:** Load color correction matrix file

**Flow:**
1. User clicks button → triggers file input
2. User selects file (.csv, .txt, or .json)
3. Set ccmFile state
4. Log file name

**Note:** File is not uploaded to backend immediately; used during correction

---

### 6.2 Image Processing Functions

#### detectChart()
**Trigger:** Click on "Detect Chart" button  
**Purpose:** Detect color calibration chart in selected image

**Validation:**
- Requires: images.length > 0
- Requires: selectedImage is set

**Flow:**
1. Find index of selected image
2. Send request to backend with image index
3. Backend returns detection result
4. If detected:
   - Set chartDetected = true
   - Update preview with visualization image
   - Log success message with confidence
   - Log identified patches
5. If not detected:
   - Set chartDetected = false
   - Log warning

**Backend API:**
- Endpoint: `http://localhost:5000/api/detect-chart`
- Method: POST
- Body: JSON `{image_index: number}`
- Response: 
  ```javascript
  {
    success: boolean,
    detection: {
      detected: boolean,
      message: string,
      confidence: number,
      visualization: string (URL),
      patch_data: Array<{name: string, ...}>
    }
  }
  ```

---

#### runCC()
**Trigger:** Click on "Run Correction" button  
**Purpose:** Execute color correction pipeline on selected image

**Validation:**
- Requires: images.length > 0
- Auto-selects first image if none selected (with confirmation)

**Flow:**
1. Confirm image selection
2. Find selected image index
3. Collapse corrections panel
4. Clear previous results
5. Set running = true
6. Build request payload with:
   - Image index
   - Enabled corrections (FFC, GC, WB, CC)
   - All settings objects
   - Delta E computation flag
   - Selected method
7. Send to backend `/api/process-image`
8. Process response:
   - Update available images
   - Update preview with corrected image
   - Store Delta E values
   - Store comparison data
   - Store scatter plot data
9. Optionally show result dialogs
10. Set running = false
11. Log completion

**Backend API:**
- Endpoint: `http://localhost:5000/api/process-image`
- Method: POST
- Body: JSON with extensive configuration
- Response:
  ```javascript
  {
    success: boolean,
    message: string,
    corrected_image_url: string,
    available_images: Array<string>,
    delta_e: Object<string, number>,
    comparison_urls: {
      original: string,
      corrected: string,
      difference: string
    },
    scatter_data: any,
    // ... more fields
  }
  ```

---

#### applyColorCorrection()
**Trigger:** Click on "Apply to Others" → Select images → Confirm  
**Purpose:** Apply trained correction model to other images

**Validation:**
- Requires: Chart detected on reference image
- Requires: At least one image selected

**Flow:**
1. Open dialog with image selection
2. User selects target images
3. Send batch request with selected indices
4. Process each image using saved model
5. Update results for each image
6. Log progress for each
7. Show completion summary

**Backend API:**
- Endpoint: `http://localhost:5000/api/apply-correction`
- Method: POST
- Body: JSON `{image_indices: Array<number>, settings: {...}}`
- Response: Array of correction results

---

#### processAllImages() / processAllImagesParallel()
**Trigger:** Click on "Process All" button  
**Purpose:** Process all loaded images independently

**Options:**
- Sequential: One at a time
- Parallel: Multiple threads (configurable)

**Flow:**
1. User clicks "Process All"
2. Dialog asks for thread count (1-8)
3. Initialize batch progress
4. For each image:
   - Detect chart
   - Run full correction pipeline
   - Update progress
   - Log results
5. Display completion summary
6. Reset progress after 3 seconds

**Backend API:**
- Uses same endpoints as single image processing
- Calls repeated for each image

---

### 6.3 Result Management Functions

#### openSaveDialog()
**Trigger:** Click on "Save" button  
**Purpose:** Select and save corrected images

**Flow:**
1. Fetch list of available images from backend
2. Open dialog with checkboxes for each image type
3. User selects desired images
4. User chooses save directory (via backend browse)
5. Call saveImages() with selections

**Backend API:**
- Endpoint: `http://localhost:5000/api/list-results`
- Method: GET
- Response: `{available_images: Array<string>}`

---

#### saveImages()
**Trigger:** Confirm button in save dialog  
**Purpose:** Save selected images to disk

**Flow:**
1. Validate selections
2. Send save request to backend
3. Backend writes files to directory
4. Log success/failure

**Backend API:**
- Endpoint: `http://localhost:5000/api/save-images`
- Method: POST
- Body: JSON `{images: Array<string>, directory: string}`
- Response: `{message: string, saved_count: number}`

---

#### saveModel()
**Trigger:** Confirm button in model save dialog  
**Purpose:** Save trained correction model

**Flow:**
1. User specifies folder name
2. Send request to backend
3. Backend serializes model to .pkl file
4. Log success/failure

**Backend API:**
- Endpoint: `http://localhost:5000/api/save-model`
- Method: POST
- Body: JSON `{folder: string}`
- Response: `{message: string, model_path: string}`

---

### 6.4 System Control Functions

#### restartBackend()
**Trigger:** Click on "Restart" button  
**Purpose:** Restart Flask backend server

**Flow:**
1. Log restart request
2. Send restart signal to backend
3. Backend initiates graceful restart
4. Wait for confirmation
5. Log success/failure

**Backend API:**
- Endpoint: `http://localhost:5000/api/restart`
- Method: POST
- Response: `{message: string}`

**Note:** In some implementations, this may close and reopen the backend process

---

#### exitApplication()
**Trigger:** Click on "Exit" button  
**Purpose:** Close entire application

**Flow:**
1. Show confirmation dialog
2. If confirmed:
   - Send shutdown signal to backend
   - In Electron: call app.quit()
   - In browser: close window/tab
3. Log exit

**Backend API:**
- Endpoint: `http://localhost:5000/api/shutdown`
- Method: POST
- Response: None (server shuts down)

---

#### clearImages()
**Trigger:** Click on "Clear All" button  
**Purpose:** Reset application state

**Flow:**
1. Clear all state variables
2. Reset file inputs
3. Send clear request to backend
4. Backend clears session data
5. Log completion

**Backend API:**
- Endpoint: `http://localhost:5000/api/clear-session`
- Method: POST
- Response: `{message: string}`

---

### 6.5 UI Interaction Functions

#### Toggle Collapsible Sections
**Triggers:** Click on section headers  
**Affected Sections:**
- Corrections
- Batch Ops
- Analysis
- Data
- System

**Logic:**
- Each section has its own expanded state
- Click toggles between expanded/collapsed
- Icon rotates: ▶ (collapsed) ↔ ▼ (expanded)
- Content animates in/out

---

#### Select Image
**Trigger:** Click on thumbnail in gallery  
**Purpose:** Change main preview image

**Logic:**
1. User clicks thumbnail
2. Set selectedImage to clicked image URL
3. Main preview updates
4. Thumbnail shows selected border/ring

---

#### Log Auto-Scroll
**Trigger:** New log message added  
**Purpose:** Keep latest logs visible

**Logic:**
- useEffect watches logs state
- On change, scrolls container to bottom
- User can manually scroll to view history

---

## 7. API Integration

### Backend Base URL
```
http://localhost:5000
```

### API Endpoints Summary

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/upload-images` | POST | Upload one or more images |
| `/api/upload-white-image` | POST | Upload white reference image |
| `/api/detect-chart` | POST | Detect color chart in image |
| `/api/process-image` | POST | Run full correction pipeline |
| `/api/apply-correction` | POST | Apply model to multiple images |
| `/api/list-results` | GET | Get available result images |
| `/api/save-images` | POST | Save selected images to disk |
| `/api/save-model` | POST | Save trained model |
| `/api/clear-session` | POST | Clear backend session data |
| `/api/restart` | POST | Restart backend server |
| `/api/shutdown` | POST | Shutdown backend server |

### Request/Response Patterns

**All responses include:**
```javascript
{
  success: boolean,  // Operation status
  message: string,   // Human-readable message
  // ... additional fields
}
```

**Error handling:**
- Catch network errors
- Check response.ok status
- Parse error messages from response text
- Log errors to activity log

---

## 8. Modals & Dialogs

### 8.1 Modal Component (Reusable)

**Props:**
- `isOpen: boolean` - Visibility state
- `onClose: function` - Close handler
- `title: string` - Modal title
- `children: ReactNode` - Modal content
- `maxWidth: string` - Max width class (default: 'max-w-2xl')

**Structure:**
```
Backdrop (full screen, semi-transparent)
├─ Modal Container (centered, white)
│  ├─ Header Row
│  │  ├─ Title (left)
│  │  └─ Close Button (right, X icon)
│  └─ Content (scrollable)
```

**Animations:**
- Backdrop: `animate-fadeIn` (opacity fade)
- Container: `animate-slideUp` (slide up + fade)

**Behavior:**
- Click backdrop: closes modal
- Click content: does not close
- ESC key: closes modal (implement if needed)

---

### 8.2 Settings Modals

Each correction type (FFC, GC, WB, CC) has its own settings modal.

#### FFC Settings Modal

**Fields:**
1. **Fit Method** (dropdown)
   - Options: Linear, PLS, Neural Network, SVM
   - Default: PLS

2. **Bins** (number input)
   - Range: 10-200
   - Default: 50

3. **Smooth Window** (number input)
   - Range: 3-21 (odd numbers)
   - Default: 5

4. **Polynomial Degree** (number input)
   - Range: 1-10
   - Default: 3

5. **Max Iterations** (number input)
   - Range: 100-10000
   - Default: 1000

6. **Tolerance** (number input)
   - Scientific notation allowed
   - Default: 1e-8

7. **Random Seed** (number input)
   - Default: 0

8. **Manual Crop** (checkbox)
   - Default: false

9. **Interactions** (checkbox)
   - Default: true

10. **Verbose** (checkbox)
    - Default: false

**Layout:** Grid with 2 columns for numeric inputs

---

#### GC Settings Modal

**Fields:**
1. **Max Degree** (number input)
   - Range: 1-10
   - Default: 5

**Description:** Simpler modal with single setting

---

#### WB Settings Modal

**Fields:**
Currently appears to use default settings or may be similar to GC.

---

#### CC Settings Modal

**Fields:**
1. **CC Method** (dropdown)
   - Options: 'ours', 'conventional'
   - Default: 'ours'

2. **Method** (dropdown)
   - Options: Various (Finlayson 2015, etc.)
   - Default: 'Finlayson 2015'

3. **Model Type** (dropdown)
   - Options: 'pls', 'nn' (neural network)
   - Default: 'pls'

4. **Degree** (number input)
   - Default: 2

5. **Max Iterations** (number input)
   - Default: 10000

6. **Tolerance** (number input)
   - Default: 1e-8

7. **Random State** (number input)
   - Default: 0

8. **N Samples** (number input)
   - Default: 50

**PLS-specific:**
9. **N Components** (number input)
   - Default: 1

**Neural Network-specific:**
10. **N Layers** (number input)
    - Default: 100

11. **Hidden Layers** (array input)
    - Default: [64, 32, 16]

12. **Learning Rate** (number input)
    - Default: 0.001

13. **Batch Size** (number input)
    - Default: 16

14. **Patience** (number input)
    - Default: 10

15. **Dropout Rate** (number input)
    - Default: 0.2

16. **Optimizer** (dropdown)
    - Options: 'adam', 'sgd', etc.
    - Default: 'adam'

17. **Use Batch Norm** (checkbox)
    - Default: true

18. **Verbose** (checkbox)
    - Default: false

**Layout:** Conditional fields based on model type

---

### 8.3 Result Dialogs

#### Delta E Dialog

**Content:**
- Table of Delta E values
- Rows: Each correction type (FFC, GC, WB, CC)
- Columns: Metric name, Value
- Color coding: Green (good) to Red (bad)

**Metrics:**
- Mean Delta E
- Max Delta E
- Standard Deviation
- Per-correction breakdown

---

#### Difference Viewer Dialog

**Content:**
- Large difference image (pixel-wise absolute difference)
- Heatmap overlay (optional)
- Color scale legend

---

#### Before/After Comparison Dialog

**Content:**
- Two images side by side
- Left: Original
- Right: Corrected
- Slider control to reveal (optional)

---

#### RGB Scatter Plot Dialog

**Content:**
- 3D scatter plot (or 2D projections)
- Shows RGB value distribution
- Before vs. After comparison
- Axes: R, G, B channels

---

### 8.4 Action Dialogs

#### Apply to Others Dialog

**Structure:**
1. **Header:**
   - Title: "Apply Color Correction to Other Images"
   - Description: "Select images to apply the correction model"

2. **Image Selection:**
   - Checkbox list of all loaded images
   - Shows thumbnail + filename
   - Select All / Deselect All buttons

3. **Actions:**
   - Cancel button
   - Apply button (disabled if none selected)

---

#### Process All Dialog

**Structure:**
1. **Header:**
   - Title: "Process All Images"
   - Warning: "This will process each image independently"

2. **Settings:**
   - Thread count slider (1-8)
   - Explanation of parallel processing

3. **Actions:**
   - Cancel button
   - Process button

---

#### Save Images Dialog

**Structure:**
1. **Header:**
   - Title: "Save Corrected Images"

2. **Image Selection:**
   - Checkboxes for each correction step
     - □ Original
     - □ FFC Result
     - □ GC Result
     - □ WB Result
     - ☑ CC Result (default)
   - Shows preview thumbnails

3. **Destination:**
   - Directory path input
   - Browse button

4. **Actions:**
   - Cancel button
   - Save button

---

#### Model Management Dialog

**Structure:**
1. **Header:**
   - Title: "Manage Models"

2. **Tabs:**
   - Save Model
   - Load Model (future)

3. **Save Tab:**
   - Model name input
   - Folder path input
   - Save button

4. **Actions:**
   - Close button

---

## 9. Responsive Design Breakpoints

### Tailwind Breakpoints

| Prefix | Min Width | Description |
|--------|-----------|-------------|
| (none) | 0px | Mobile (default) |
| `sm:` | 640px | Small tablet |
| `md:` | 768px | Tablet |
| `lg:` | 1024px | Laptop |
| `xl:` | 1280px | Desktop |
| `2xl:` | 1536px | Large Desktop |

### Responsive Patterns

#### Layout
- **Mobile/Tablet:** Single column (stack all sections)
- **Desktop (lg+):** Two columns (3:9 ratio)

#### Typography
```
Mobile    → Tablet   → Desktop
text-2xl  → text-3xl → text-4xl   (Main title)
text-xs   → text-sm  → text-base  (Section headers)
px-2      → px-3     → px-4       (Padding)
py-1.5    → py-2     → py-2.5     (Button vertical padding)
```

#### Images
```
Mobile → Tablet → Desktop
250px  → 350px  → 450px → 550px  (Max height)
```

#### Spacing
```
Mobile → Desktop
gap-3  → gap-6 → gap-8  (Grid gaps)
p-2    → p-4   → p-8    (Page padding)
mb-3   → mb-6           (Margins)
```

#### Thumbnails
```
Mobile → Tablet → Desktop
h-12   → h-16   → h-20  (Gallery thumbnail size)
```

---

## 10. Animation & Transitions

### CSS Animations (defined in index.css)

#### fadeIn
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
Duration: 0.2s
Easing: ease-out
```

#### slideUp
```css
@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}
Duration: 0.3s
Easing: ease-out
```

#### slideDown
```css
@keyframes slideDown {
  from {
    transform: translateY(-10px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}
Duration: 0.2s
Easing: ease-out
```

#### pulse (slow)
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}
Duration: 2s
Easing: cubic-bezier(0.4, 0, 0.6, 1)
Repeat: infinite
```

#### shimmer
```css
@keyframes shimmer {
  0% { background-position: -1000px 0; }
  100% { background-position: 1000px 0; }
}
Duration: 2s
Repeat: infinite
```

#### bounce-subtle
```css
@keyframes bounce-subtle {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-5px); }
}
Duration: 2s
Easing: ease-in-out
Repeat: infinite
```

### Transition Classes

#### Standard Transitions
```
transition-all         → All properties
transition-colors      → Color properties only
transition-shadow      → Shadow only
transition-transform   → Transform only

duration-200           → 200ms
duration-300           → 300ms

ease-out               → Deceleration curve
ease-in-out            → Smooth curve
```

#### Interactive States
```
hover:shadow-lg        → Shadow increase on hover
hover:scale-105        → Slight grow on hover
hover:scale-110        → Medium grow on hover
active:scale-95        → Press down effect
active:scale-98        → Subtle press
```

### Component-Specific Animations

#### Buttons
- Default: `transition-all duration-200`
- Hover: Shadow increase, color shift
- Active: `scale-95` or `scale-98`
- Disabled: No transitions

#### Modals
- Backdrop: `animate-fadeIn`
- Content: `animate-slideUp`

#### Collapsible Sections
- Content: `animate-slideDown`
- Icon: Rotate 180deg (smooth)

#### Progress Bar
- Fill: `transition-all duration-300 ease-out`
- Shimmer: Continuous animation

#### Image Thumbnails
- Hover: `scale-110`, shadow increase
- Select: Immediate (no transition on border)

#### Run Button (Idle)
- `animate-pulse-slow` (2s cycle)
- Draws attention without being distracting

---

## 11. Reusable Components

### 11.1 Modal

**Props:**
```javascript
{
  isOpen: boolean,
  onClose: function,
  title: string,
  children: ReactNode,
  maxWidth?: string = 'max-w-2xl'
}
```

**Render Logic:**
```
if (!isOpen) return null

Render:
  <Backdrop onClick={onClose}>
    <Container onClick={stopPropagation} className={maxWidth}>
      <Header>
        <Title>{title}</Title>
        <CloseButton onClick={onClose}>×</CloseButton>
      </Header>
      <Content>
        {children}
      </Content>
    </Container>
  </Backdrop>
```

---

### 11.2 Card

**Props:**
```javascript
{
  children: ReactNode,
  className?: string = '',
  gradient?: boolean = false
}
```

**Styling:**
- Base: white background, rounded-xl, shadow-md, border
- Gradient (if enabled): `bg-gradient-to-br from-white to-gray-50`
- Hover: `hover:shadow-lg`

---

### 11.3 Button

**Props:**
```javascript
{
  children: ReactNode,
  onClick: function,
  variant?: 'primary' | 'secondary' | 'success' | 'danger' | 'outline' = 'primary',
  disabled?: boolean = false,
  className?: string = '',
  fullWidth?: boolean = false,
  size?: 'sm' | 'md' | 'lg' = 'md'
}
```

**Variants:**
- Primary: Indigo-purple gradient
- Secondary: Gray background, bordered
- Success: Green-emerald gradient
- Danger: Red-pink gradient
- Outline: Border only, indigo color

**Sizes:**
- sm: px-3 py-1.5 text-xs
- md: px-4 py-2 text-sm
- lg: px-6 py-3 text-base

---

### 11.4 CollapsibleSection

**Props:**
```javascript
{
  title: string,
  icon: string (emoji),
  children: ReactNode,
  defaultOpen?: boolean = false
}
```

**State:**
- Internal: `isOpen` (boolean)

**Render:**
```
<Container>
  <HeaderButton onClick={toggle}>
    <Title>
      <Icon>{icon}</Icon>
      {title}
    </Title>
    <ChevronIcon rotated={isOpen}>▼</ChevronIcon>
  </HeaderButton>
  {isOpen && (
    <Content animated>
      {children}
    </Content>
  )}
</Container>
```

---

## 12. Performance Optimizations

### 12.1 Log Batching

**Problem:** Frequent log updates cause excessive re-renders

**Solution:**
- Buffer log messages in a ref
- Flush buffer after 50ms of inactivity
- Reduces render count by 10-100x

**Implementation:**
```javascript
logsBufferRef.current.push(message)
clearTimeout(logsFlushTimerRef.current)
logsFlushTimerRef.current = setTimeout(flushBuffer, 50)
```

---

### 12.2 Memoization

**Components:**
- `Modal`: `memo()` wrapper
- `Card`: `memo()` wrapper
- `Button`: `memo()` wrapper
- `CollapsibleSection`: `memo()` wrapper

**Callbacks:**
- `handleLoadImages`: `useCallback()`
- `handleLoadWhiteImage`: `useCallback()`
- `handleLoadCCM`: `useCallback()`
- `clearImages`: `useCallback()`
- `appendLog`: `useCallback()`
- `flushLogs`: `useCallback()`

**Purpose:** Prevent unnecessary re-renders of child components

---

### 12.3 Auto-Scroll Optimization

**Implementation:**
```javascript
useEffect(() => {
  if (logContainerRef.current) {
    logContainerRef.current.scrollTop = 
      logContainerRef.current.scrollHeight
  }
}, [logs])
```

**Trigger:** Only when `logs` changes

---

## 13. Accessibility Considerations

### Keyboard Navigation
- All buttons are keyboard accessible
- Tab order follows visual hierarchy
- Enter/Space activates buttons

### ARIA Labels
- Close buttons: `aria-label="Close"`
- File inputs: Associated labels
- Disabled states: Properly marked

### Focus Management
- Modals trap focus when open
- Focus returns to trigger element on close
- Visible focus indicators on all interactive elements

### Screen Readers
- Semantic HTML elements
- Descriptive button text
- Status messages in activity log

### Color Contrast
- Text on backgrounds meets WCAG AA standards
- Important information not conveyed by color alone
- Icons supplement color-coded states

---

## 14. Error Handling Patterns

### Network Errors
```javascript
try {
  const response = await fetch(url, options)
  if (!response.ok) {
    throw new Error(`HTTP ${response.status}: ${await response.text()}`)
  }
  const data = await response.json()
  // Process data
} catch (err) {
  appendLog(`\n✗ Operation failed: ${err.message}`)
}
```

### User Input Validation
- Disable buttons when preconditions not met
- Show warning messages in logs
- Confirm destructive actions

### Backend Communication
- Always check response.ok
- Parse error messages from response body
- Log all errors to activity log
- Show user-friendly messages

---

## 15. Implementation Checklist

When recreating this UI in another language/framework:

### Phase 1: Setup
- [ ] Set up build system (equivalent to Vite)
- [ ] Configure styling solution (CSS framework or styled components)
- [ ] Set up state management
- [ ] Configure routing (if needed)

### Phase 2: Layout
- [ ] Create page container with gradient background
- [ ] Implement header with glassmorphism
- [ ] Create two-column grid layout
- [ ] Make layout responsive

### Phase 3: Components
- [ ] Build Modal component
- [ ] Build Button component with variants
- [ ] Build Card component
- [ ] Build CollapsibleSection component
- [ ] Build ProgressBar component

### Phase 4: Left Sidebar
- [ ] File Management section
- [ ] Correction Settings section (collapsible)
- [ ] Primary Action button
- [ ] Batch Operations section (collapsible)
- [ ] Analysis section (collapsible)
- [ ] Data Management section (collapsible)
- [ ] System Controls section (collapsible)
- [ ] Batch Progress Indicator
- [ ] Activity Log panel

### Phase 5: Right Panel
- [ ] Image Preview header
- [ ] Empty state
- [ ] Main image display
- [ ] Image gallery with thumbnails
- [ ] Selection logic

### Phase 6: Modals
- [ ] FFC Settings Modal
- [ ] GC Settings Modal
- [ ] WB Settings Modal
- [ ] CC Settings Modal
- [ ] Delta E Dialog
- [ ] Difference Viewer Dialog
- [ ] Before/After Dialog
- [ ] RGB Scatter Plot Dialog
- [ ] Apply to Others Dialog
- [ ] Process All Dialog
- [ ] Save Images Dialog
- [ ] Model Management Dialog

### Phase 7: Functionality
- [ ] File upload handlers
- [ ] Image detection
- [ ] Color correction execution
- [ ] Batch processing
- [ ] Result management
- [ ] Save operations
- [ ] System controls

### Phase 8: API Integration
- [ ] Set up HTTP client
- [ ] Implement all API endpoints
- [ ] Error handling
- [ ] Loading states

### Phase 9: Polish
- [ ] Add all animations
- [ ] Implement transitions
- [ ] Test responsiveness
- [ ] Add accessibility features
- [ ] Optimize performance
- [ ] Test on multiple devices

### Phase 10: Testing
- [ ] Unit tests for components
- [ ] Integration tests for workflows
- [ ] E2E tests for critical paths
- [ ] Cross-browser testing
- [ ] Performance testing

---

## 16. Additional Notes

### Backend Requirements
The UI expects a Flask backend running on `localhost:5000` with specific API endpoints. Ensure your backend implementation matches the expected request/response formats.

### Image Format Support
- Upload: All common image formats (jpg, png, tiff, etc.)
- Preview: Browser-compatible formats (jpg, png, webp)
- Processing: Backend handles format conversion

### Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- ES6+ JavaScript features
- CSS Grid and Flexbox support required
- File API support required

### Performance Targets
- Initial load: < 2s
- Image upload: < 1s for 5MB image
- UI interactions: < 100ms
- Correction processing: Depends on backend (2-30s typical)

---

## Appendix A: Complete State Tree

```javascript
ApplicationState {
  // Core Data
  images: Image[],
  whiteImage: Image | null,
  ccmFile: File | null,
  selectedImage: string | null,
  
  // UI State
  running: boolean,
  chartDetected: boolean,
  previewLabel: string,
  logs: string,
  
  // Settings
  corrections: {
    ffcEnabled: boolean,
    gcEnabled: boolean,
    wbEnabled: boolean,
    ccEnabled: boolean,
    computeDeltaE: boolean,
    showDialogsAfterCC: boolean
  },
  
  ffcSettings: FFCSettings,
  gcSettings: GCSettings,
  ccSettings: CCSettings,
  
  // Modals
  modals: {
    ffc: boolean,
    gc: boolean,
    wb: boolean,
    cc: boolean,
    model: boolean,
    save: boolean,
    deltaE: boolean,
    apply: boolean,
    processAll: boolean,
    difference: boolean,
    beforeAfter: boolean,
    scatter: boolean,
    saveSteps: boolean
  },
  
  // Collapsible Sections
  expanded: {
    corrections: boolean,
    batchOps: boolean,
    analysis: boolean,
    data: boolean,
    system: boolean
  },
  
  // Results
  availableImages: string[],
  deltaEValues: Record<string, number>,
  comparisonData: {
    original: string | null,
    corrected: string | null,
    difference: string | null
  },
  scatterPlotData: any | null,
  
  // Batch Processing
  batchProgress: {
    current: number,
    total: number,
    status: string
  },
  selectedForApply: number[],
  selectedForSave: string[],
  batchImagesList: any[],
  numThreads: number,
  
  // Save Operations
  saveDirectory: string,
  modelSaveFolder: string,
  selectedStepsToSave: string[],
  selectedImagesToSave: number[]
}
```

---

## Appendix B: Color Palette Reference

```css
/* Background Gradients */
--bg-main: linear-gradient(to-br, #030712, #312e81, #030712);
--bg-header: rgba(255, 255, 255, 0.1) with backdrop-blur;
--bg-card: linear-gradient(to-br, rgba(255,255,255,0.95), rgba(249,250,251,0.95));

/* Functional Colors */
--blue-indigo: #3b82f6 to #4f46e5;
--green-emerald-teal: #10b981 to #14b8a6;
--cyan-blue: #06b6d4 to #3b82f6;
--purple-pink: #a855f7 to #ec4899;
--amber-orange: #f59e0b to #ea580c;
--red-rose: #dc2626 to #e11d48;

/* Gray Scale */
--gray-50: #f9fafb;
--gray-100: #f3f4f6;
--gray-200: #e5e7eb;
--gray-300: #d1d5db;
--gray-400: #9ca3af;
--gray-500: #6b7280;
--gray-600: #4b5563;
--gray-700: #374151;
--gray-800: #1f2937;
--gray-900: #111827;
--gray-950: #030712;

/* Semantic Colors */
--success: #10b981;
--warning: #f59e0b;
--error: #ef4444;
--info: #3b82f6;
```

---

## Appendix C: Icon Reference

All icons in the application are emoji characters:

| Feature | Icon | Unicode |
|---------|------|---------|
| Application | 🎨 | U+1F3A8 |
| File Management | 📁 | U+1F4C1 |
| Load Images | 📸 | U+1F4F8 |
| White Image | 🟦 | U+1F7E6 |
| CCM File | 📊 | U+1F4CA |
| Detect Chart | 🔍 | U+1F50D |
| Clear/Delete | 🗑️ | U+1F5D1 |
| Settings | ⚙️ | U+2699 |
| Play/Run | ▶️ | U+25B6 |
| Batch Operations | ⚡ | U+26A1 |
| Apply | 🎨 | U+1F3A8 |
| Analysis | 📊 | U+1F4CA |
| Difference | 🔬 | U+1F52C |
| Before/After | 📷 | U+1F4F7 |
| RGB Scatter | 📈 | U+1F4C8 |
| Delta E | 📊 | U+1F4CA |
| Save | 💾 | U+1F4BE |
| Models | 📦 | U+1F4E6 |
| System | 🔧 | U+1F527 |
| Restart | 🔄 | U+1F504 |
| Exit | 🚪 | U+1F6AA |
| Activity Log | 📋 | U+1F4CB |
| Image Preview | 🖼️ | U+1F5BC |
| Chart Detected | ✓ | U+2713 |
| Tip/Info | 💡 | U+1F4A1 |
| Upload | 📤 | U+1F4E4 |
| Success | ✓ | U+2713 |
| Error | ✗ | U+2717 |
| Warning | ⚠ | U+26A0 |
| Processing | ⏳ | U+23F3 |

---

**END OF DOCUMENT**

---

This documentation provides a complete blueprint for recreating the Color Correction Studio UI in any programming language or framework. It covers every aspect of the design, functionality, and implementation details needed to build a pixel-perfect, feature-complete recreation.
