# pipeline/ — โค้ดสร้างวิดีโอ

> ⚠️ โฟลเดอร์นี้ยังว่าง — ต้องทำใน VS Code บนเครื่องคุณเด (ต้องมี ffmpeg + API keys)

---

## ทำอะไรก่อน

### 1. ก๊อปของจาก Day-Guide มา
บนเครื่องคุณเด (Windows) — Day-Guide อยู่ที่ `D:\Day-Guide` หรือ `C:\Users\dacha\youtube150226\Day-Guide`

```
คัดลอกมาไว้ที่ pipeline/
  src/            ทั้งโฟลเดอร์
  fonts/          Mitr-Bold.ttf, Kanit-Bold.ttf
  requirements.txt
  create_guide.py → เปลี่ยนชื่อเป็น create.py
```

### 2. ก๊อป Facebook upload จาก Day-News-Aus
Day-News-Aus มีโค้ดอัป Facebook อยู่แล้ว (Page: DayAi Australia) → ยืมมาเป็น `src/facebook_upload.py`

### 3. แก้ให้เข้ากับโปรเจกต์นี้
```
[ ] เพิ่ม format "reels" (9:16, 60 วิ, ตัวหนังสือกรอบดำท่อน hook)
[ ] อ่านสคริปต์จาก ../scripts/NNN-*.md แทนที่จะเขียนเอง
[ ] อัปทั้ง YouTube + Facebook ในรอบเดียว
[ ] เขียนผลลัพธ์กลับไปที่ ../content/status.md อัตโนมัติ
```

---

## โครงสร้างที่วางไว้

```
pipeline/
├── create.py                 ตัวหลัก
├── repurpose.py              ตัด long-form → shorts
├── requirements.txt
├── src/
│   ├── google_tts.py         เสียงไทย (ฟรี)
│   ├── pexels_video.py       คลิป stock (ฟรี)
│   ├── veo_video.py          คลิป AI (มีค่าใช้จ่าย)
│   ├── avatar_video.py       ⬅ ต้องเขียนใหม่ (ดู docs/05-AVATAR.md)
│   ├── text_overlay.py       ตัวหนังสือไทย
│   ├── transcriber.py        จับเวลาคำ
│   ├── video_assembler.py    ประกอบวิดีโอ
│   ├── thumbnail_generator.py
│   ├── youtube_upload.py
│   └── facebook_upload.py    ⬅ ยืมจาก Day-News-Aus
└── fonts/
```

---

## ⚠️ ห้ามลืม

- **ห้าม commit `.env`** — มี API key อยู่ข้างใน (`.gitignore` กันไว้แล้ว)
- **ห้าม commit ไฟล์ .mp4** — ใหญ่เกิน git รับไม่ไหว
- **ห้ามไปแก้ไฟล์ใน Day-Guide** — ก๊อปมาแก้ในนี้เท่านั้น
- อ่าน `docs/04-PIPELINE.md` ก่อนเริ่มเขียนโค้ด (มี Known Bugs รออยู่)
