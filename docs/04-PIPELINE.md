# 04 — ระบบสร้างวิดีโออัตโนมัติ

> ⚠️ **ส่วนนี้เป็นสเปก — โค้ดจริงต้องทำใน VS Code บนเครื่องคุณเด** (ต้องมี ffmpeg + API keys + ไฟล์วิดีโอใหญ่)

---

## 1. ไม่ต้องเขียนใหม่ — ยืมจาก Day-News-Aus

> ❌ **Day-Guide เลิกใช้แล้ว** (โปรเจกต์ที่ทำแล้วไม่สำเร็จ) — อย่าไปอ้างอิง
> ✅ ระบบที่ **ใช้งานจริงและรันทุกวัน** คือ `C:\Users\dacha\youtube150226\Day-News-Aus`
> (โค้ดของ Day-Guide ถูกก๊อปไปอยู่ใน `Day-News-Aus/src/guide/` หมดแล้ว)

### ของที่ Day-News-Aus มีให้ยืม (ตรวจสอบแล้วว่ามีจริง)

| ไฟล์ใน Day-News-Aus | ทำอะไร | เอามาใช้ |
|---|---|---|
| `src/google_tts.py` | เสียงไทย Google TTS (ฟรี) | ✅ ใช้ได้เลย |
| `src/youtube_upload.py` | อัป YouTube อัตโนมัติ | ✅ ใช้ได้เลย |
| `src/facebook_upload.py` | **อัป Facebook อัตโนมัติ** | ✅ ใช้ได้เลย ⭐ |
| `src/facebook_refresh_tokens.py` | ต่ออายุ token Facebook | ✅ ใช้ได้เลย |
| `src/tiktok_upload.py` | อัป TikTok | ⚠️ มีแต่ไม่ใช้ (auto ยอดตก อัปมือดีกว่า) |
| `src/shorts_frame_generator.py` | สร้างเฟรมคลิปแนวตั้ง | ✅ ใช้ได้เลย |
| `src/long_frame_generator.py` | สร้างเฟรมคลิปแนวนอน | ✅ ใช้ได้เลย |
| `src/video_creator.py` | ประกอบวิดีโอ | ✅ ใช้ได้เลย |
| `src/guide/pexels_video.py` | ดึงคลิป stock Pexels (ฟรี) | ✅ ใช้ได้เลย |
| `src/guide/text_overlay.py` | ใส่ตัวหนังสือไทย | ✅ ใช้ได้เลย |
| `src/guide/transcriber.py` | subtitle จับเวลาคำ | ✅ ใช้ได้เลย |
| `src/guide/video_assembler.py` | ประกอบวิดีโอ (ตัวเต็ม) | ✅ ใช้ได้เลย |
| `src/guide/thumbnail_generator.py` | ทำ thumbnail | ✅ ใช้ได้เลย |
| `create_aus_shorts.py` | **ตัวอย่าง runner ที่ใช้งานจริง** | ✅ ใช้เป็นแม่แบบ |
| `run_full_pipeline.py` | คุม flow ทั้งหมด | ✅ ใช้เป็นแม่แบบ |
| `automation/daily_news.bat` + `*.ps1` | ตั้งเวลารันอัตโนมัติทุกวัน (Windows Task Scheduler) | ✅ ก๊อปมาแก้ |
| `skills/HOOK_WRITING.md` (34KB) | กฎเขียน hook/title/CTA | ✅ อ่านประกอบกับ `03-HOOK-FORMULAS.md` |
| `skills/SHORT_PEXELS.md` (43KB) | ขั้นตอนทำ Short + Pexels | ✅ อ่านก่อนเขียนโค้ด |
| `fonts/` | ฟอนต์ไทย Mitr/Kanit | ✅ ก๊อปมา |
| `list_avatars.py`, `create_transparent_avatar.py` | **โค้ด HeyGen Avatar** | ⚠️ ดู `05-AVATAR.md` |

**สิ่งที่ต้องเขียนเพิ่ม:**
| ต้องทำ | ทำไม |
|---|---|
| `create.py` | runner ของโปรเจกต์นี้ — อ่านสคริปต์จาก `../scripts/` แทนที่จะไปหาข่าว |
| `src/avatar_video.py` | ปรับโค้ด HeyGen เดิมให้ใช้ **หน้าคุณเด** + เสียง Google TTS (ของเดิมใช้ avatar สำเร็จรูป + Botnoi ซึ่งเลิกใช้แล้ว) |
| `src/repurpose.py` | ตัด long-form → Shorts อัตโนมัติ |

> ⚠️ **ห้ามไปแก้ไฟล์ใน Day-News-Aus** — มันรันอัตโนมัติทุกวัน แก้แล้วพัง = ช่องข่าว 4 ช่องหยุด
> ก๊อปมาไว้ใน `pipeline/` แล้วแก้ในนี้เท่านั้น

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

## 5. ที่เก็บไฟล์ — ไดรฟ์ไหน (สำคัญ!)

### สภาพเครื่องคุณเด
```
C: = SSD  (ระบบ + งานที่รันอยู่จริง)   ← Day-News-Aus อยู่ที่นี่ รันทุกวัน
D: = HDD  (จานหมุน — ช้า แต่พื้นที่เยอะ)
```

### ✅ วางตรงนี้
```
C:\Users\dacha\youtube150226\
├── Day-News-Aus\                  ← ระบบข่าว (ห้ามแตะ รันทุกวัน)
└── Day-ThaiShop-Marketing\        ← ⭐ โปรเจกต์นี้ วางข้างกัน
```

**ทำไมไม่วาง D: ทั้งที่พื้นที่เยอะกว่า**

| เรื่อง | SSD (C:) | HDD (D:) |
|---|---|---|
| ffmpeg เรนเดอร์วิดีโอ | เร็ว | **ช้ากว่า 10-20 เท่า** (ffmpeg เขียนไฟล์ชั่วคราวตลอดเวลา) |
| `git status` / `git checkout` | ทันที | **ค้างหลายวินาที** (ไฟล์เล็กเยอะ = HDD แย่ที่สุด) |
| เปิดโปรเจกต์ใน VS Code | ทันที | หมุนรอ |

→ **HDD ไม่ได้ห้ามใช้ แต่ห้ามใช้เป็นที่ทำงาน**

### 📦 ให้ D: (HDD) ทำหน้าที่เป็นคลังเก็บแทน

```
D:\video-archive\
├── uploaded\        วิดีโอที่อัปขึ้นช่องแล้ว (ย้ายมาจาก C: ทุกสัปดาห์)
├── avatar-source\   วิดีโอต้นฉบับสำหรับสร้าง avatar (ไฟล์ใหญ่ ไม่ต้องเร็ว)
└── backup\          สำรองข้อมูล
```

ตั้งใน `.env`:
```
ARCHIVE_DIR=D:\video-archive
```
→ pipeline เรนเดอร์ที่ C: (เร็ว) → เสร็จแล้วย้ายไป D: (ประหยัดพื้นที่ SSD)

> ⚠️ **ห้ามวางโปรเจกต์ใน `Documents` / `Desktop` / `OneDrive`** — OneDrive จะพยายามอัปโหลดไฟล์ .mp4 หลาย GB ตลอดเวลา ทำให้ git และการเรนเดอร์พัง
> `C:\Users\dacha\youtube150226\` ปลอดภัย เพราะ Day-News-Aus ใช้อยู่แล้วโดยไม่มีปัญหา

---

## 6. ตั้งค่าครั้งแรก (ทำใน VS Code)

```powershell
# 1. clone มาที่เครื่อง — วางข้างๆ Day-News-Aus
cd C:\Users\dacha\youtube150226
git clone https://github.com/Dayqr/Day-ThaiShop-Marketing
cd Day-ThaiShop-Marketing

# 2. ก๊อป pipeline จาก Day-News-Aus (ไม่ใช่ Day-Guide!)
xcopy /E /I ..\Day-News-Aus\src pipeline\src
xcopy /E /I ..\Day-News-Aus\fonts pipeline\fonts
copy ..\Day-News-Aus\requirements.txt pipeline\

# 3. ติดตั้ง
python -m venv venv
venv\Scripts\activate
pip install -r pipeline\requirements.txt

# 4. สร้างไฟล์ .env (ห้าม commit!)
#    ก๊อปค่าจาก Day-News-Aus\.env ที่ใช้งานได้อยู่แล้ว
copy ..\Day-News-Aus\.env.example .env
```

**ค่าที่ต้องใส่ใน `.env`:**
```
PEXELS_API_KEY=...                      (ฟรี)
GOOGLE_APPLICATION_CREDENTIALS=...      (ฟรี — Google TTS)
YOUTUBE_CLIENT_ID=... / _SECRET=...     (ฟรี)
FACEBOOK_PAGE_TOKEN=...                 (ฟรี)
HEYGEN_API_KEY=...                      (⚠️ มีค่ารายเดือน — ใส่ทีหลังได้)
ARCHIVE_DIR=D:\video-archive
```

**ต้องมีติดเครื่อง:** Python 3.11+ · ffmpeg · git

> ⚠️ **ช่อง YouTube/Facebook ต้องใช้คนละ credential กับ Day-News-Aus** — สร้าง OAuth ใหม่สำหรับช่องใหม่ อย่าใช้ token เดิม ไม่งั้นคลิปจะไปโผล่ผิดช่อง

---

## 7. ⚠️ Known Bugs (จากระบบเดิม — ระวังซ้ำ)

| ปัญหา | อาการ | วิธีเลี่ยง |
|---|---|---|
| สคริปต์ยาวเกิน | คลิปยาวกว่าที่ตั้งใจมาก | ล็อกจำนวนตัวอักษร: Reels ≤ 900 ตัว, Short ≤ 1,400 ตัว |
| คลิป Pexels วนซ้ำ | เห็นคลิปเดิมหลายรอบในคลิปเดียว | เก็บ list คลิปที่ใช้แล้ว ห้ามซ้ำในคลิปเดียวกัน |
| ตัวหนังสือไทยขึ้นเป็นกล่อง | ฟอนต์ไม่รองรับไทย | ใช้ Mitr-Bold.ttf หรือ Kanit-Bold.ttf เท่านั้น |
| path ฟอนต์บน Windows ใน ffmpeg | ffmpeg error | ต้อง escape เป็น `D\:/path/font.ttf` |
| รันหลายช่องพร้อมกัน | โดน rate limit | รันทีละอัน |

> เจอบั๊กใหม่ → **เพิ่มในตารางนี้ทันที** (กฎจาก CLAUDE.md)

---

## 8. สถานะปัจจุบัน

```
[ ] clone โปรเจกต์ลง C:\Users\dacha\youtube150226\Day-ThaiShop-Marketing
[ ] ก๊อป src/ + fonts/ จาก Day-News-Aus มาไว้ใน pipeline/
[ ] สร้าง OAuth ใหม่สำหรับช่อง YouTube + Facebook Page ใหม่
[ ] เขียน create.py (อ่านสคริปต์จาก ../scripts/ แทนการหาข่าว)
[ ] แก้ให้รองรับ format reels (9:16, 60 วิ)
[ ] เพิ่ม repurpose.py (ตัด long → shorts)
[ ] เพิ่ม avatar_video.py (ดู 05-AVATAR.md)
[ ] ตั้ง Task Scheduler ให้รันอัตโนมัติ (ก๊อปจาก Day-News-Aus/automation/)
[ ] ทดสอบสร้างคลิปแรกจนจบ
```
