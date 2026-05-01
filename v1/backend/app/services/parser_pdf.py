import fitz
from typing import Optional
from fastapi import HTTPException
from sqlmodel import Session
from app.models import ExecutionUnit, Step

def parse_pdf_toc(
    session: Session,
    file_bytes: bytes,
    user_id: int,
    title: Optional[str] = None,
    unit_id: Optional[int] = None
):
    if not title and not unit_id:
        raise HTTPException(status_code=400, detail="Either title or unit_id must be provided")

    # 1. Open PDF
    try:
        doc = fitz.open(stream=file_bytes, filetype="pdf")
        toc = doc.get_toc() # [level, title, page]
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Failed to parse PDF: {str(e)}")

    # 2. Filter level 1 chapters
    chapters = [entry for entry in toc if entry[0] == 1]
    
    if not chapters:
        return {"requires_manual_input": True}

    # 3. Get or Create ExecutionUnit
    if unit_id:
        unit = session.get(ExecutionUnit, unit_id)
        if not unit or unit.user_id != user_id:
            raise HTTPException(status_code=404, detail="Execution Unit not found")
    else:
        unit = ExecutionUnit(
            title=title,
            type="book",
            status="backlog",
            total_hours=0.0,
            user_id=user_id
        )
        session.add(unit)
        session.commit()
        session.refresh(unit)

    # 4. Create Steps from Chapters
    steps_to_create = []
    page_count = doc.page_count

    for i, entry in enumerate(chapters):
        level, chapter_title, start_page = entry
        
        # Determine end page
        if i + 1 < len(chapters):
            end_page = chapters[i+1][2] - 1
        else:
            end_page = page_count

        # weight = page count
        weight = float(max(1, end_page - start_page + 1))

        step = Step(
            execution_unit_id=unit.id,
            title=chapter_title,
            order_index=i + 1,
            weight=weight,
            allocated_hours=0.0,
            status="pending"
        )
        steps_to_create.append(step)

    # 5. Persist
    for step in steps_to_create:
        session.add(step)
    
    session.commit()
    doc.close()

    return {
        "unit_id": unit.id,
        "number_of_chapters": len(steps_to_create)
    }
