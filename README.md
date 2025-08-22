# Mock Exam Paper Generator

A Flask web application that automatically generates professional mock exam papers and mark schemes from uploaded study materials using AI.

## Features

### 📄 File Processing
- **Multi-format support**: .txt, .pdf, .docx, .pptx, .rtf
- **OCR capability**: Extracts text from image-based PDFs using Tesseract
- **Smart text extraction**: Handles encrypted PDFs, zip bombs, and malformed files
- **Duplicate detection**: Automatically removes duplicate content via SHA-256 hashing

### 🎯 Question Generation
- **4 Question Types**: Long answer, Short answer, Multiple Choice (MCQ), Math/Calculation
- **3 Difficulty Levels**: Easy, Medium, Hard with adaptive complexity
- **Smart content analysis**: AI identifies and prioritizes exam-relevant material
- **LaTeX math support**: Comprehensive Unicode-to-LaTeX conversion for mathematical content

### ⚙️ Advanced Customization
- **Per-question control**: Set individual question types, difficulties, and additional instructions
- **Drag-and-drop reordering**: Rearrange questions in the advanced interface
- **Blueprint-driven generation**: Precise control over exam structure
- **Math-heavy optimization**: Enhanced processing for calculation-heavy subjects

### 📊 PDF Output
- **Professional formatting**: Clean, exam-ready PDFs using LaTeX/Tectonic
- **Two documents**: Separate question paper and detailed mark scheme
- **Chemical notation**: Full support for chemical arrows and scientific symbols
- **Error recovery**: Automatic LaTeX error fixing and compilation retry

### 🔒 Security & Performance
- **Rate limiting**: Per-IP limits on uploads, downloads, and status checks
- **File validation**: Content-type verification and malware protection
- **Progress tracking**: Real-time generation status with time estimates
- **Concurrent processing**: Parallel file processing and AI calls
- **Memory management**: Smart token budgeting and text chunking

## Requirements

### System Dependencies
```bash
# LaTeX compiler (required)
tectonic

# OCR support (optional but recommended)
tesseract-ocr
```

### Python Dependencies
```bash
pip install flask openai python-dotenv
pip install python-docx PyMuPDF pdfplumber
pip install python-pptx striprtf pillow pytesseract
pip install werkzeug
```

## Setup

1. **Install system dependencies**:
   ```bash
   # Ubuntu/Debian
   sudo apt install tectonic tesseract-ocr
   
   # macOS
   brew install tectonic tesseract
   ```

2. **Clone and install**:
   ```bash
   git clone <repository-url>
   cd <repository-name>
   pip install -r requirements.txt
   ```

3. **Configure environment**:
   ```bash
   # Create .env file
   OPENAI_API_KEY=your_openai_api_key_here
   
   # Optional configuration
   APP_HOST=0.0.0.0
   APP_PORT=5000
   FLASK_DEBUG=0
   
   # Model selection
   OPENAI_MODEL_MAIN=gpt-4o-mini
   OPENAI_MODEL_SUMMARY=gpt-4o-mini
   
   # File limits
   APP_MAX_FILES=30
   APP_MAX_FILE_MB=25
   APP_TOTAL_UPLOAD_MB=100
   
   # Security (optional)
   APP_BASIC_AUTH=0
   APP_USER=admin
   APP_PASS=admin
   ```

4. **Run the application**:
   ```bash
   python exam.py
   ```

## Usage

1. **Upload study materials**: Drag and drop or select files (.txt, .pdf, .docx, .pptx, .rtf)
2. **Set exam parameters**: Choose title, number of questions, and global difficulty
3. **Advanced customization** (optional): 
   - Toggle per-question topic instructions
   - Set individual question difficulties
   - Customize question types
   - Reorder questions via drag-and-drop
4. **Generate**: Click "Generate PDFs" and monitor real-time progress
5. **Download**: Get both the question paper and mark scheme as separate PDFs

## API Endpoints

### Core Endpoints
- `GET /` - Main web interface
- `POST /upload` - Generate exam papers (supports file uploads and form data)
- `GET /status?job=<id>` - Check generation progress
- `POST /cancel` - Cancel ongoing generation
- `GET /download/questions` - Download question paper PDF
- `GET /download/answers` - Download mark scheme PDF

### Health & Monitoring
- `GET /healthz` - Liveness check
- `GET /readyz` - Readiness check (validates dependencies)
- `GET /download/manifest` - Get metadata about last generation

### Development
- `GET /smoke/local` - Test LaTeX compilation

## Configuration Options

### File Processing
```bash
APP_TXT_CHAR_LIMIT=1000000        # Max characters per text file
APP_PDF_PAGE_LIMIT=2000           # Max PDF pages to process
APP_DOCX_PARA_LIMIT=50000         # Max paragraphs per Word doc
APP_TOTAL_TEXT_CHAR_CAP=3000000   # Total text limit across all files
```

### OCR Settings
```bash
APP_ENABLE_OCR=1                  # Enable OCR for image-based PDFs
APP_OCR_DPI=300                   # Rendering DPI for OCR
APP_OCR_LANG=eng                  # Tesseract language (e.g., "eng+deu")
```

### AI Model Settings
```bash
APP_SUMMARY_TOKENS=700            # Target tokens per file summary
APP_Q_INPUT_CAP=12000            # Max input tokens for question generation
APP_Q_OUT_CAP=4000               # Max output tokens for questions
APP_A_OUT_CAP=2500               # Max output tokens for answers
```

### Security & Rate Limiting
```bash
APP_RATE_UPLOADS_PER_MIN=6        # Upload requests per IP per minute
APP_RATE_STATUS_PER_10S=50        # Status checks per IP per 10 seconds
APP_RATE_DOWNLOADS_PER_MIN=60     # Downloads per IP per minute
```

## Architecture

### Question Generation Pipeline
1. **File Processing**: Extract and normalize text from uploaded files
2. **Content Analysis**: Create intelligent summaries optimized for exam content
3. **Question Generation**: AI generates questions following the specified blueprint
4. **Answer Generation**: Create detailed mark schemes with multiple acceptable answers
5. **LaTeX Processing**: Convert mathematical notation and compile to PDF
6. **Quality Assurance**: Validate and repair LaTeX, upgrade trivial questions

### Smart Features
- **Adaptive summarization**: Chooses between full text or summaries based on content length
- **Math enhancement**: Prioritizes mathematical content when generating calculation questions
- **Difficulty enforcement**: Automatically upgrades questions that don't meet difficulty requirements
- **LaTeX sanitization**: Comprehensive Unicode-to-LaTeX conversion with error recovery

## Development

### Testing
```bash
# Test LaTeX compilation
curl http://localhost:5000/smoke/local

# Health checks
curl http://localhost:5000/healthz
curl http://localhost:5000/readyz
```

### Logging
The application logs to stdout with configurable levels. Key events include:
- File processing progress
- AI model calls and token usage
- LaTeX compilation status
- Security events (rate limiting, authentication)

## License

Use as you wish, but please provide credit :)
