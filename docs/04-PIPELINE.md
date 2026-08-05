# 04 — ระบบสร้างวิดีโออัตโนมัติ

> ⚠️ **ส่วนนี้เป็นสเปก — โค้ดจริงต้องทำใน VS Code บนเครื่องคุณเด** (ต้องมี ffmpeg + API keys + ไฟล์วิดีโอใหญ่)

---

## 1. ไม่ต้องเขียนใหม่ — ยืมจาก Day-Guide

`Dayqr/Day-Guide` มี pipeline ที่ใช้งานได้จริงอยู่แล้ว ก๊อปมาไว้ใน `pipeline/`

| ไฟล์ใน Day-Guide | ทำอะไร | เอามาใช้ |
|---|---|---|
| `create_guide.py` | ตัวหลัก — คุม flow ทั้งหมด | ✅ ก๊อปมาแก้ |
| `src/google_tts.py` | แปลงข้อความเป็นเสียงไทย (ฟรี) | ✅ ใช้ได้เลย |
| `src/pexels_video.py` | ดึงคลิป stock จาก Pexels (ฟรี) | ✅ ใช้ได้เลย |
| `src/veo_video.py` | สร้างคลิปด้วย Google Veo (AI) | ✅ ใช้ได้เลย |
| `src/text_overlay.py` | ใส่ตัวหนังสือไทยบนวิดีโอ | ✅ ใช้ได้เลย |
| `src/video_assembler.py` | ประกอบเป็นวิดีโอ | ✅ ใช้ได้เลย |
| `src/thumbnail_generator.py` | ทำ thumbnail | ✅ ใช้ได้เลย |
| `src/transcriber.py` | ทำ subtitle จับเวลาคำ | ✅ ใช้ได้เลย |
| `src/youtube_upload.py` | อัป YouTube อัตโนมัติ | ✅ ใช้ได้เลย |
| `fonts/Mitr-Bold.ttf`, `Kanit-Bold.ttf` | ฟอนต์ไทย | ✅ ก๊อปมา |

**สิ่งที่ต้องเพิ่มใหม่ (Day-Guide ยังไม่มี):**
| ต้องทำ | ทำไม |
|---|---|
| `src/facebook_upload.py` | Facebook คือช่องทางหลักของกลุ่มนี้ (Day-News-Aus มีโค้ดนี้ ยืมมาได้) |
| `src/avatar_video.py` | ต่อกับ HeyGen/Synthesia — ดู `05-AVATAR.md` |
| `src/repurpose.py` | ตัด long-form → Shorts อัตโนมัติ |

---

## 2. Flow ที่ต้องการ

```
content/topic-bank.md
        │  เลือกหัวข้อ
        ▼
Claude เขียนสคริปต์ (อ่าน 03-HOOK-FORMULAS.md ก่อน)
        │  → scripts/NNN-ชื่อหัวข้อ.md
        ▼
┌───────────────────────────────────────────┐
│  pipeline/                                 │
│  1. อ่านสคริปต์                             │
│  2. Google TTS → เสียงไทย                  │
│  3. จับเวลาคำ (transcriber)                │
│  4. หาคลิป: Pexels / Veo / Avatar          │
│  5. ใส่ตัวหนังสือไทย + hook กรอบดำ           │
│  6. ประกอบ + ใส่เพลง                        │
│  7. ทำ thumbnail 2-3 แบบ                   │
└───────────────────────────────────────────┘
        ▼
   ┌─────────┬──────────┬─────────┐
   ▼         ▼          ▼         ▼
YouTube  YT Shorts  FB Reels  TikTok
 (auto)    (auto)    (auto)   (อัปมือ)
        ▼
content/status.md  ← อัปเดตสถานะ + ลิงก์
```

---

## 3. คำสั่งที่อยากให้ใช้ (ออกแบบไว้ — ยังไม่ได้เขียน)

```bash
# สร้าง Reels 60 วินาที จากหัวข้อที่ 12
python create.py --topic 12 --format reels

# สร้าง long-form 10 นาที
python create.py --topic 12 --format long

# ตัด long-form ที่มีอยู่ → Shorts 3 คลิป
python repurpose.py --video output/012-long.mp4 --count 3

# ใช้ AI avatar แทนคลิป stock
python create.py --topic 12 --format reels --avatar
```

---

## 4. กฎการใช้ API (ห้ามเผาเงิน)

```
✅ ฟรี — ใช้ได้เต็มที่
   Pexels API          คลิป stock
   Google Cloud TTS    เสียงไทย (free tier)
   YouTube Data API    อัปคลิป
   Facebook Graph API  อัปคลิป
   YouTube Audio Library  เพลง

⚠️ มีค่าใช้จ่าย — ถามคุณเดก่อนทุกครั้ง
   Google Veo          คลิป AI
   HeyGen / Synthesia  AI Avatar

❌ ห้ามใช้เด็ดขาด (ตัดสินใจไปแล้ว)
   ElevenLabs          แพงเกิน
   Botnoi Voice        เลิกใช้แล้ว
```

**Pipeline ไม่ต้องเรียก Anthropic/OpenAI API** — Claude ใน VS Code เขียนสคริปต์ให้เอง = ไม่มีค่า API

---

## 5. ตั้งค่าครั้งแรก (ทำใน VS Code)

```bash
# 1. clone มาที่เครื่อง
git clone https://github.com/Dayqr/Day-ThaiShop-Marketing
cd Day-ThaiShop-Marketing

# 2. ก๊อป pipeline จาก Day-Guide
#    (Windows) copy โฟลเดอร์ src\ และ fonts\ จาก D:\Day-Guide มาไว้ที่ pipeline\

# 3. ติดตั้ง
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt

# 4. สร้างไฟล์ .env (ห้าม commit!)
#    PEXELS_API_KEY=...
#    GOOGLE_APPLICATION_CREDENTIALS=...
#    YOUTUBE_CLIENT_SECRET=...
#    FACEBOOK_PAGE_TOKEN=...
```

**ต้องมีติดเครื่อง:** Python 3.11+ · ffmpeg · ImageMagick (ถ้า Day-Guide ใช้)

---

## 6. ⚠️ Known Bugs (จาก Day-Guide — ระวังซ้ำ)

| ปัญหา | อาการ | วิธีเลี่ยง |
|---|---|---|
| สคริปต์ยาวเกิน | คลิปยาวกว่าที่ตั้งใจมาก | ล็อกจำนวนตัวอักษร: Reels ≤ 900 ตัว, Short ≤ 1,400 ตัว |
| คลิป Pexels วนซ้ำ | เห็นคลิปเดิมหลายรอบในคลิปเดียว | เก็บ list คลิปที่ใช้แล้ว ห้ามซ้ำในคลิปเดียวกัน |
| ตัวหนังสือไทยขึ้นเป็นกล่อง | ฟอนต์ไม่รองรับไทย | ใช้ Mitr-Bold.ttf หรือ Kanit-Bold.ttf เท่านั้น |
| path ฟอนต์บน Windows ใน ffmpeg | ffmpeg error | ต้อง escape เป็น `D\:/path/font.ttf` |
| รันหลายช่องพร้อมกัน | โดน rate limit | รันทีละอัน |

> เจอบั๊กใหม่ → **เพิ่มในตารางนี้ทันที** (กฎจาก CLAUDE.md)

---

## 7. สถานะปัจจุบัน

```
[ ] ก๊อป pipeline จาก Day-Guide มาไว้ใน pipeline/
[ ] แก้ให้รองรับ format reels (9:16, 60 วิ)
[ ] เพิ่ม facebook_upload.py (ยืมจาก Day-News-Aus)
[ ] เพิ่ม repurpose.py (ตัด long → shorts)
[ ] เพิ่ม avatar_video.py (ดู 05-AVATAR.md)
[ ] ทดสอบสร้างคลิปแรกจนจบ
```
