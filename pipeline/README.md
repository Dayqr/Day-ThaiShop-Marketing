# pipeline/ — โค้ดสร้างวิดีโอ

> ⚠️ โฟลเดอร์นี้ยังว่าง — ต้องทำใน VS Code บนเครื่องคุณเด (ต้องมี ffmpeg + API keys)

---

## 📍 ที่เก็บโปรเจกต์

```
C:\Users\dacha\youtube150226\Day-ThaiShop-Marketing\     ← วางที่นี่ (C: = SSD)
D:\video-archive\                                         ← D: (HDD) เก็บวิดีโอที่อัปแล้ว
```

**อย่าวางโปรเจกต์บน D:** — D: เป็น HDD เรนเดอร์วิดีโอช้ากว่า SSD 10-20 เท่า และ git จะค้าง
รายละเอียดใน `docs/04-PIPELINE.md` หัวข้อ 5

---

## ทำอะไรก่อน

### 1. ก๊อปของจาก **Day-News-Aus** มา (ไม่ใช่ Day-Guide!)

> ❌ `Day-Guide` เลิกใช้แล้ว — โปรเจกต์ที่ทำแล้วไม่สำเร็จ
> ✅ `C:\Users\dacha\youtube150226\Day-News-Aus` คือระบบที่รันจริงทุกวัน

```powershell
cd C:\Users\dacha\youtube150226\Day-ThaiShop-Marketing
xcopy /E /I ..\Day-News-Aus\src pipeline\src
xcopy /E /I ..\Day-News-Aus\fonts pipeline\fonts
copy ..\Day-News-Aus\requirements.txt pipeline\
```

ได้มาครบเลย: `google_tts.py` · `youtube_upload.py` · `facebook_upload.py` ·
`shorts_frame_generator.py` · `guide/pexels_video.py` · `guide/text_overlay.py` ·
`guide/transcriber.py` · `guide/video_assembler.py` · `guide/thumbnail_generator.py`

### 2. อ่านของเดิมก่อนเขียนโค้ดใหม่
```
Day-News-Aus\create_aus_shorts.py        ← ตัวอย่าง runner ที่ใช้งานจริง
Day-News-Aus\run_full_pipeline.py        ← flow ทั้งหมด
Day-News-Aus\skills\SHORT_PEXELS.md      ← ขั้นตอนละเอียด 43KB
Day-News-Aus\skills\HOOK_WRITING.md      ← กฎเขียน hook 34KB
Day-News-Aus\automation\daily_news.bat   ← วิธีตั้งให้รันอัตโนมัติ
```

### 3. แก้ให้เข้ากับโปรเจกต์นี้
```
[ ] เขียน create.py — อ่านสคริปต์จาก ../scripts/NNN-*.md (ไม่ต้องไปหาข่าว)
[ ] เพิ่ม format "reels" (9:16, 60 วิ, hook กรอบดำ)
[ ] อัปทั้ง YouTube + Facebook ในรอบเดียว
[ ] เขียนผลลัพธ์กลับไปที่ ../content/status.md อัตโนมัติ
[ ] แก้ avatar_video.py — เปลี่ยนจาก Botnoi → Google TTS, เปลี่ยน avatar → หน้าคุณเด
[ ] ย้ายไฟล์ที่เสร็จแล้วไป D:\video-archive\uploaded\
```

---

## ⚠️ ห้ามลืม

- 🚨 **ห้ามไปแก้ไฟล์ใน Day-News-Aus** — มันรันอัตโนมัติทุกวัน แก้แล้วพัง = ช่องข่าว 4 ช่องหยุด ก๊อปมาแก้ในนี้เท่านั้น
- **ต้องสร้าง OAuth ใหม่** สำหรับช่อง YouTube + Facebook Page ใหม่ อย่าใช้ token ของ Day-News-Aus ไม่งั้นคลิปไปโผล่ผิดช่อง
- **ห้าม commit `.env`** — มี API key อยู่ข้างใน (`.gitignore` กันไว้แล้ว)
- **ห้าม commit ไฟล์ .mp4** — ใหญ่เกิน git รับไม่ไหว
- อ่าน `docs/04-PIPELINE.md` ก่อนเริ่มเขียนโค้ด (มี Known Bugs รออยู่)
