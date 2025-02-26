# STL to STEP Converter API

<!-- <img src="https://example.com/project-thumbnail.png" alt="Project Thumbnail: STL to STEP Converter" width="600" ALIGN="left" HSPACE="20" VSPACE="20"/> -->

## Overview
This project provides a **command-line utility** to convert **STL files** to **STEP (ISO 10303-21) files**. The translation is a direct triangle-to-triangle conversion with tolerance-based merging of edges. The `stltostp` tool translates without depending on third-party tools such as OpenCascade or FreeCAD.

<!-- 📜 **Read the full documentation here:** [STL to STEP Converter Documentation](https://example.com/documentation) -->

## Installation

### Linux / MacOS:
```powershell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Ballistyxx/stl-to-step/main/install.sh)"
```

### Windows:
Currently a work in progress! For Windows systems, you can use WSL and the Linux/MacOS command to build the program.
<!-- ```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Ballistyxx/stl-to-step/main/install.ps1'))
``` -->

## Features
✔ **Converts ASCII and binary STL files** to STEP files  
✔ **Merges edges** based on a specified tolerance  
✔ **Outputs STEP files** compliant with ISO 10303-21  
✔ **Simple command-line interface**  
✔ **No dependencies** on external libraries  

<!-- ## Project Images

### Example Conversion
<img src="https://example.com/example-conversion.png" alt="Example Conversion: STL to STEP" width="500" ALIGN="left" HSPACE="20" VSPACE="20"/> -->

## Hardware Components
- **Standard PC** with a C++11 compatible compiler
- **CMake 3.10 or higher**

## Software & Code
The project is implemented in **C++** and uses **CMake** for build configuration. The software includes:

- **Command-line interface** for easy usage
- **Tolerance-based edge merging** for accurate conversions
- **Support for both ASCII and binary STL files**

### Example Usage
```sh
stltostp <input_file.stl> <output_file.stp> [tolerance]
```

### 3D Printing Files & PCB Design
All source code and build files for the project are provided in the repository.

📂 Download Here: [GitHub Repository](https://github.com/Ballistyxx/stl-to-step)

🛠️ **Installation:** Clone this repository and follow the build instructions provided in the Installation section.

### Known Limitations & Future Improvements
⚠ Limited Error Handling – Improve error handling for edge cases.
⚠ Performance Optimization – Optimize the conversion process for large STL files.
⚠ Additional File Formats – Add support for other 3D file formats in future updates.

### License
This project is open-source under the MIT License. See the LICENSE file for details.

### Author
Developed by w3gen, installer streamlining by Eli Ferrara

📧 Contact: [GitHub Issues](https://github.com/Ballistyxx/stl-to-step/issues)

✨ If you like this project, consider giving it a ⭐ on GitHub!