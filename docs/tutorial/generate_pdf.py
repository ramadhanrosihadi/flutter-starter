import os
import re
from reportlab.lib.pagesizes import A5
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.enums import TA_CENTER, TA_LEFT, TA_JUSTIFY
from reportlab.pdfgen import canvas

# Define target paths
DOCS_DIR = r"c:\Users\62822\Documents\Work\flutter\flutter-starter\docs\tutorial"
OUTPUT_PDF = r"c:\Users\62822\Documents\Work\flutter\flutter-starter\docs\tutorial\flutter_starter_tutorial_mobile.pdf"

# Tutorial files in chronological order
TUTORIAL_FILES = [
    "00_overview.md",
    "01_monorepo_melos.md",
    "02_clean_architecture.md",
    "03_riverpod_generator.md",
    "04_local_cache_drift.md",
    "05_mason_bricks.md",
    "06_barrel_exports_l10n.md",
    "07_multi_flavor_environment.md",
    "08_implementasi_api_baru.md"
]

class NumberedCanvas(canvas.Canvas):
    """Canvas that performs a two-pass render to print total page numbers in footer."""
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super().showPage()
        super().save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont("Helvetica", 8)
        self.setFillColor(colors.HexColor("#64748B"))
        
        # Don't draw headers/footers on page 1 (cover page)
        if self._pageNumber > 1:
            # Header
            self.drawString(20, 565, "Panduan Belajar Flutter Starter Monorepo")
            self.setStrokeColor(colors.HexColor("#E2E8F0"))
            self.setLineWidth(0.5)
            self.line(20, 558, 400, 558)
            
            # Footer
            self.drawString(20, 20, "© 2026 Antigravity IDE • Google DeepMind")
            page_text = f"Halaman {self._pageNumber} dari {page_count}"
            self.drawRightString(400, 20, page_text)
            self.line(20, 32, 400, 32)
            
        self.restoreState()

def clean_markdown_line(line):
    """Formats markdown syntax into HTML-like tags supported by ReportLab Paragraph."""
    # Escape HTML special chars except those we explicitly generate
    line = line.replace("&", "&amp;")
    
    # Format line breaks: <br> -> <br/> to satisfy ReportLab XML parser
    line = re.sub(r"<br\s*>", "<br/>", line, flags=re.IGNORECASE)
    
    # Format bold: **text** -> <b>text</b>
    line = re.sub(r"\*\*(.*?)\*\*", r"<b>\1</b>", line)
    
    # Format italic: *text* -> <i>text</i>
    line = re.sub(r"\*(.*?)\*", r"<i>\1</i>", line)
    
    # Format code tags: `code` -> <font name="Courier" color="#2563EB">code</font>
    line = re.sub(r"`([^`]+)`", r'<font face="Courier-Bold" color="#2563EB">\1</font>', line)
    
    # Format markdown links: [text](url) -> <u>text</u> (simplified for pdf)
    line = re.sub(r"\[(.*?)\]\((.*?)\)", r'<font color="#1D4ED8"><u>\1</u></font>', line)
    
    # Format standard bullets and checkbox lists
    line = re.sub(r"^-\s+`\[\s*\]`", "•  ", line)
    line = re.sub(r"^-\s+`\[x\]`", "✓  ", line)
    line = re.sub(r"^-\s+", "•  ", line)
    line = re.sub(r"^\*\s+", "•  ", line)
    line = re.sub(r"^\d+\.\s+", lambda m: m.group(0) + " ", line) # Add spaces after list numbers
    
    return line

def parse_markdown_to_story(file_path, styles):
    story = []
    
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')
    
    in_code_block = False
    code_lines = []
    code_lang = ""
    
    in_quote_block = False
    quote_lines = []
    quote_type = "NOTE" # NOTE, TIP, WARNING, CAUTION, IMPORTANT
    
    in_table = False
    table_rows = []
    
    for line in lines:
        stripped = line.strip()
        
        # --- Handle Code Blocks ---
        if stripped.startswith("```"):
            if in_code_block:
                # Close code block
                in_code_block = False
                code_text = "\n".join(code_lines)
                code_p = Paragraph(f'<font face="Courier" size="8" color="#0F172A">{code_text.replace("<", "&lt;").replace(">", "&gt;")}</font>', styles['CodeBlock'])
                
                # Wrap inside a neat grey rounded cell
                t = Table([[code_p]], colWidths=[380])
                t.setStyle(TableStyle([
                    ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#F8FAFC")),
                    ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
                    ('TOPPADDING', (0,0), (-1,-1), 8),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 8),
                    ('LEFTPADDING', (0,0), (-1,-1), 10),
                    ('RIGHTPADDING', (0,0), (-1,-1), 10),
                ]))
                story.append(t)
                story.append(Spacer(1, 8))
                code_lines = []
            else:
                in_code_block = True
                code_lang = stripped[3:].strip()
            continue
            
        if in_code_block:
            # Preserve spacing in code blocks by using non-breaking spaces or tabs
            formatted_line = line.replace("  ", "&nbsp;&nbsp;")
            code_lines.append(formatted_line)
            continue

        # --- Handle Blockquotes & Alerts ---
        if stripped.startswith(">"):
            # Check alert tags: [!NOTE], [!TIP], [!WARNING], [!CAUTION], [!IMPORTANT]
            alert_match = re.search(r"> \s*\[!(NOTE|TIP|WARNING|CAUTION|IMPORTANT)\]", line, re.IGNORECASE)
            if alert_match:
                in_quote_block = True
                quote_type = alert_match.group(1).upper()
                continue
            
            if in_quote_block:
                clean_quote_line = stripped[1:].strip()
                quote_lines.append(clean_quote_line)
            else:
                # Standard blockquote
                in_quote_block = True
                quote_type = "QUOTE"
                quote_lines.append(stripped[1:].strip())
            continue
        elif in_quote_block and not stripped.startswith(">") and stripped != "":
            # Continue blockquote if line is not empty
            quote_lines.append(stripped)
            continue
        elif in_quote_block and (stripped == "" or line == lines[-1]):
            # Close Quote Block
            in_quote_block = False
            quote_text = " ".join(quote_lines)
            quote_lines = []
            
            # Determine color theme
            theme_color = colors.HexColor("#3B82F6") # Note/Quote: Blue
            bg_color = colors.HexColor("#EFF6FF")
            title_text = "CATATAN"
            if quote_type == "TIP":
                theme_color = colors.HexColor("#10B981") # Green
                bg_color = colors.HexColor("#ECFDF5")
                title_text = "TIPS"
            elif quote_type == "WARNING" or quote_type == "CAUTION":
                theme_color = colors.HexColor("#EF4444") # Red
                bg_color = colors.HexColor("#FEF2F2")
                title_text = "PERINGATAN!"
            elif quote_type == "IMPORTANT":
                theme_color = colors.HexColor("#F59E0B") # Yellow/Orange
                bg_color = colors.HexColor("#FFFBEB")
                title_text = "PENTING!"
            
            quote_body = clean_markdown_line(quote_text)
            if quote_type != "QUOTE":
                p_text = f"<b>{title_text}</b><br/>{quote_body}"
            else:
                p_text = f"<i>{quote_body}</i>"
                
            quote_p = Paragraph(p_text, styles['AlertText'])
            t = Table([[quote_p]], colWidths=[380])
            t.setStyle(TableStyle([
                ('BACKGROUND', (0,0), (-1,-1), bg_color),
                ('BOX', (0,0), (-1,-1), 0.5, colors.HexColor("#E2E8F0")),
                ('LINEBEFORE', (0,0), (0,-1), 3.5, theme_color),
                ('TOPPADDING', (0,0), (-1,-1), 8),
                ('BOTTOMPADDING', (0,0), (-1,-1), 8),
                ('LEFTPADDING', (0,0), (-1,-1), 10),
                ('RIGHTPADDING', (0,0), (-1,-1), 10),
            ]))
            story.append(t)
            story.append(Spacer(1, 8))
            continue

        # --- Handle Markdown Tables ---
        if stripped.startswith("|") and not in_table:
            in_table = True
            table_rows = []
            
            # Read cells
            cells = [c.strip() for c in stripped.split("|")[1:-1]]
            table_rows.append(cells)
            continue
        elif in_table:
            if stripped.startswith("|"):
                # Skip the alignment separator row like `| :--- | :--- |`
                if re.match(r"^\|[\s:-|]+$", stripped):
                    continue
                cells = [c.strip() for c in stripped.split("|")[1:-1]]
                table_rows.append(cells)
                continue
            else:
                # End of table
                in_table = False
                # Format and generate ReportLab Table
                formatted_data = []
                # Header row
                header_row = [Paragraph(f"<b>{clean_markdown_line(c)}</b>", styles['TableHeader']) for c in table_rows[0]]
                formatted_data.append(header_row)
                
                # Data rows
                for r in table_rows[1:]:
                    data_row = [Paragraph(clean_markdown_line(c), styles['TableBody']) for c in r]
                    formatted_data.append(data_row)
                
                # Determine smart column widths
                num_cols = len(table_rows[0])
                col_width = 380 / num_cols
                
                t = Table(formatted_data, colWidths=[col_width]*num_cols)
                t_styles = [
                    ('BACKGROUND', (0,0), (-1,0), colors.HexColor("#0F172A")),
                    ('TEXTCOLOR', (0,0), (-1,0), colors.white),
                    ('BOTTOMPADDING', (0,0), (-1,0), 6),
                    ('TOPPADDING', (0,0), (-1,-1), 6),
                    ('BOTTOMPADDING', (0,0), (-1,-1), 6),
                    ('GRID', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
                ]
                
                # Alternating row colors
                for idx in range(1, len(formatted_data)):
                    if idx % 2 == 0:
                        t_styles.append(('BACKGROUND', (0,idx), (-1,idx), colors.HexColor("#F8FAFC")))
                        
                t.setStyle(TableStyle(t_styles))
                story.append(t)
                story.append(Spacer(1, 10))
                table_rows = []
                continue

        # --- Handle Headings & Standard Paragraphs ---
        if stripped.startswith("# "):
            story.append(Spacer(1, 15))
            clean_text = clean_markdown_line(stripped[2:])
            story.append(Paragraph(clean_text, styles['Heading1']))
            story.append(Spacer(1, 8))
        elif stripped.startswith("## "):
            story.append(Spacer(1, 12))
            clean_text = clean_markdown_line(stripped[3:])
            story.append(Paragraph(clean_text, styles['Heading2']))
            story.append(Spacer(1, 6))
        elif stripped.startswith("### "):
            story.append(Spacer(1, 10))
            clean_text = clean_markdown_line(stripped[4:])
            story.append(Paragraph(clean_text, styles['Heading3']))
            story.append(Spacer(1, 4))
        elif stripped == "---":
            story.append(Spacer(1, 10))
            # Drawer a thin decorative line
            t = Table([[""]], colWidths=[380], rowHeights=[1])
            t.setStyle(TableStyle([
                ('LINEBELOW', (0,0), (-1,-1), 0.5, colors.HexColor("#CBD5E1")),
                ('BOTTOMPADDING', (0,0), (-1,-1), 0),
                ('TOPPADDING', (0,0), (-1,-1), 0),
            ]))
            story.append(t)
            story.append(Spacer(1, 10))
        elif stripped != "":
            # Normal lines / Bullet lists
            clean_line = clean_markdown_line(line)
            if clean_line.startswith("•") or clean_line.startswith("✓"):
                # Indented bullet point
                story.append(Paragraph(clean_line, styles['CustomBullet']))
            else:
                story.append(Paragraph(clean_line, styles['Body']))
            story.append(Spacer(1, 4))
            
    return story

def main():
    print("Preparing PDF document styles...")
    styles = getSampleStyleSheet()
    
    # Premium Typography & Custom Styles for Mobile (A5 Size)
    primary_color = colors.HexColor("#0F172A") # Deep Slate Blue
    accent_color = colors.HexColor("#2563EB")  # Vivid Indigo
    body_color = colors.HexColor("#334155")    # Readability Slate Gray
    
    styles.add(ParagraphStyle(
        'CoverTitle',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=24,
        leading=30,
        alignment=TA_CENTER,
        textColor=primary_color,
        spaceAfter=15
    ))

    styles.add(ParagraphStyle(
        'CoverSubtitle',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=12,
        leading=16,
        alignment=TA_CENTER,
        textColor=accent_color,
        spaceAfter=40
    ))

    styles.add(ParagraphStyle(
        'CoverMeta',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=9,
        leading=14,
        alignment=TA_CENTER,
        textColor=colors.HexColor("#64748B"),
        spaceAfter=4
    ))
    
    styles['Heading1'].fontName = 'Helvetica-Bold'
    styles['Heading1'].fontSize = 16
    styles['Heading1'].leading = 20
    styles['Heading1'].textColor = primary_color
    styles['Heading1'].keepWithNext = True
    
    styles['Heading2'].fontName = 'Helvetica-Bold'
    styles['Heading2'].fontSize = 12
    styles['Heading2'].leading = 16
    styles['Heading2'].textColor = primary_color
    styles['Heading2'].keepWithNext = True
    
    styles['Heading3'].fontName = 'Helvetica-Bold'
    styles['Heading3'].fontSize = 10
    styles['Heading3'].leading = 13
    styles['Heading3'].textColor = accent_color
    styles['Heading3'].keepWithNext = True

    styles['BodyText'].fontName = 'Helvetica'
    styles['BodyText'].fontSize = 9.5
    styles['BodyText'].leading = 14
    styles['BodyText'].textColor = body_color
    styles['BodyText'].alignment = TA_LEFT
    
    # Custom styles
    styles.add(ParagraphStyle(
        'Body',
        parent=styles['BodyText'],
        spaceAfter=0
    ))
    
    styles.add(ParagraphStyle(
        'CustomBullet',
        parent=styles['BodyText'],
        leftIndent=15,
        spaceAfter=0
    ))

    styles.add(ParagraphStyle(
        'CodeBlock',
        parent=styles['Normal'],
        fontName='Courier',
        fontSize=7.5,
        leading=10,
        textColor=colors.HexColor("#0F172A"),
        spaceAfter=0
    ))

    styles.add(ParagraphStyle(
        'AlertText',
        parent=styles['BodyText'],
        fontSize=9,
        leading=13,
        spaceAfter=0
    ))

    styles.add(ParagraphStyle(
        'TableHeader',
        parent=styles['Normal'],
        fontName='Helvetica-Bold',
        fontSize=8.5,
        leading=11,
        textColor=colors.white
    ))

    styles.add(ParagraphStyle(
        'TableBody',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=8,
        leading=11,
        textColor=body_color
    ))

    doc = SimpleDocTemplate(
        OUTPUT_PDF,
        pagesize=A5,
        leftMargin=20,
        rightMargin=20,
        topMargin=40,
        bottomMargin=45
    )

    story = []

    # --- Generate Cover Page ---
    story.append(Spacer(1, 80))
    # Elegant Cover Art (Table placeholder)
    cover_logo = Paragraph('<font size="32" color="#2563EB"><b>F</b></font>', styles['CoverTitle'])
    logo_table = Table([[cover_logo]], colWidths=[60], rowHeights=[60])
    logo_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor("#EFF6FF")),
        ('BOX', (0,0), (-1,-1), 2, colors.HexColor("#2563EB")),
        ('ALIGN', (0,0), (-1,-1), 'CENTER'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('TOPPADDING', (0,0), (-1,-1), 10),
        ('BOTTOMPADDING', (0,0), (-1,-1), 0),
    ]))
    story.append(logo_table)
    story.append(Spacer(1, 30))
    story.append(Paragraph("FLUTTER STARTER", styles['CoverTitle']))
    story.append(Paragraph("Panduan Pembelajaran Lengkap Tingkat Enterprise", styles['CoverSubtitle']))
    
    # Bottom metadata
    story.append(Spacer(1, 100))
    story.append(Paragraph("DILENGKAPI DENGAN 8 MODUL PEMBELAJARAN:", styles['CoverMeta']))
    story.append(Paragraph("Monorepo Melos • Clean Architecture • Riverpod Generator", styles['CoverMeta']))
    story.append(Paragraph("Drift SQLite Storage • Mason CLI • Multi-Flavor & API Integration", styles['CoverMeta']))
    story.append(Spacer(1, 20))
    story.append(Paragraph("Penerbit: Antigravity AI Consultant", styles['CoverMeta']))
    story.append(Paragraph("Tahun Rilis: 2026", styles['CoverMeta']))
    story.append(PageBreak())

    # --- Compile and Parse Markdown Files ---
    for f_name in TUTORIAL_FILES:
        file_path = os.path.join(DOCS_DIR, f_name)
        print(f"Parsing {f_name}...")
        file_story = parse_markdown_to_story(file_path, styles)
        story.extend(file_story)
        
        # Add PageBreak between modules to keep it clean and book-like
        if f_name != TUTORIAL_FILES[-1]:
            story.append(PageBreak())

    # Build PDF Document
    print(f"Compiling beautiful PDF to {OUTPUT_PDF}...")
    doc.build(story, canvasmaker=NumberedCanvas)
    print("SUCCESS: Mobile PDF has been compiled successfully!")

if __name__ == '__main__':
    main()
