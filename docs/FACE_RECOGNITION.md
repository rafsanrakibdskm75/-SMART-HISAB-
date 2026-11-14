# Face Recognition (v1.1.0) — স্মার্ট ফেস আইডি ভেরিফিকেশন

Design screen #19 (`face_scan_verification`) implemented: the camera
identifies an enrolled customer and opens their record (profile /
collection / baki status).

## How it works (all on-device, fully offline)
1. **Enroll** — from a person's profile ("ফেস আইডি" card): take their
   photo. ML Kit detects the face; quality gates reject bad samples
   (too far, turned/tilted head, eyes closed, more than one face).
   Up to 3 samples per person; a 4th replaces the oldest.
2. **Embedding** — the face crop runs through MobileFaceNet
   (`assets/models/mobilefacenet.tflite`, 5.2 MB, 192-dim output),
   producing a normalised number vector. **The photo itself is not
   stored as part of the enrollment** — only the vector.
3. **Scan** — Person list → face icon (top right) → take a photo.
   Cosine similarity against every enrolled person:
   - best ≥ 0.70 and clearly ahead → matched; the person's card shows
     name, mobile, match % and baki due.
   - best two within 0.08 of each other → **ambiguous**: both cards are
     shown and a human picks. The app never guesses between lookalikes.
   - below 0.70 → no match; search the list manually.

## Safety rules (by design, do not relax)
- A face match is a **finder, never an authorisation**. Scanning never
  posts a payment or edits anything; staff confirm on screen first.
- **Embeddings are device-local**: they live in the `face_enrollments`
  table (schema v3), are never added to the sync queue, never uploaded
  to Firestore, and are excluded from backups/snapshots. Consequence:
  **each device enrolls its own customers.** A customer enrolled on
  phone A is not recognised on phone B until enrolled there too.
- Deleting a person (soft delete) removes them from matching at once;
  removing the enrollment from the profile deletes the vectors.

## Honest limits — read before relying on it
- Accuracy is **not** the 99.4% in the design mock — that number was
  artwork. Real MobileFaceNet under shop lighting is good but not
  perfect: poor light, masks, sunglasses, big age/weight changes and
  identical twins can fool or block it. That is exactly why ambiguous
  results go to a human.
- This build is **compile-verified and math-verified** (verify_stage11,
  30 checks; Drift roundtrip test on a real SQLite table). Camera,
  ML Kit and the TFLite model can only be truly exercised on a physical
  phone — run the face steps in `docs/DEVICE_TEST_CHECKLIST.md` after
  installing the APK.
- APK grows: ML Kit + TFLite libraries + the model add roughly
  15–25 MB. On 2–3 GB RAM phones a scan takes about a second.
- Model provenance: MobileFaceNet TFLite build as used by the public
  FaceRecognitionAuth project (GitHub, MCarlomagno). If you ship
  commercially, re-check the model licence for your use.

## Tuning knobs
`lib/domain/face_recognition.dart`:
`defaultMatchThreshold` (0.70), `defaultAmbiguityMargin` (0.08),
`FaceEnrollment.maxSamples` (3), quality-gate angles in
`checkEnrollQuality`. Raise the threshold if strangers ever match;
lower it slightly if enrolled customers keep missing in good light.
