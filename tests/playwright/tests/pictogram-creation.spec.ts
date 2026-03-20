import { test, expect } from "@playwright/test";
import {
  getAuthToken,
  setupOrg,
  deleteOrg,
  makeTestPng,
  makeTestMp3,
} from "./helpers";

const CORE_URL = process.env.CORE_URL ?? "http://localhost:8000";

let token: string;
let orgId: number;

test.beforeAll(async ({ request }) => {
  const initialToken = await getAuthToken(request);
  const setup = await setupOrg(request, initialToken);
  token = setup.token;
  orgId = setup.orgId;
});

test.afterAll(async ({ request }) => {
  await deleteOrg(request, orgId, token);
});

function jsonHeaders() {
  return {
    Authorization: `Bearer ${token}`,
    "Content-Type": "application/json",
  };
}

function authHeader() {
  return { Authorization: `Bearer ${token}` };
}

// ── Create pictogram via JSON (with AI flags) ───────────────

test("create pictogram with generate_image flag", async ({ request }) => {
  const res = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "test-ai-pictogram",
      image_url: "https://example.com/placeholder.png",
      organization_id: orgId,
      generate_image: true,
      generate_sound: true,
    },
  });

  expect(res.status()).toBe(201);
  const body = await res.json();
  expect(body.id).toBeTruthy();
  expect(body.name).toBe("test-ai-pictogram");
  expect(body.organization_id).toBe(orgId);
  // sound_url may or may not be populated depending on whether giraf-ai is running
  expect(body).toHaveProperty("sound_url");
  expect(body).toHaveProperty("image_url");
});

test("create pictogram without AI generation", async ({ request }) => {
  const res = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "static-pictogram",
      image_url: "https://example.com/cat.png",
      organization_id: orgId,
      generate_image: false,
      generate_sound: false,
    },
  });

  expect(res.status()).toBe(201);
  const body = await res.json();
  expect(body.name).toBe("static-pictogram");
  expect(body.image_url).toContain("example.com");
});

// ── Upload pictogram with image file ────────────────────────

test("upload pictogram with image file", async ({ request }) => {
  const png = makeTestPng();

  const res = await request.post(`${CORE_URL}/api/v1/pictograms/upload`, {
    headers: authHeader(),
    multipart: {
      name: "uploaded-pictogram",
      organization_id: String(orgId),
      generate_sound: "false",
      image: {
        name: "test.png",
        mimeType: "image/png",
        buffer: png,
      },
    },
  });

  expect(res.status()).toBe(201);
  const body = await res.json();
  expect(body.name).toBe("uploaded-pictogram");
  expect(body.image_url).toBeTruthy();
});

test("upload pictogram with image and sound files", async ({ request }) => {
  const png = makeTestPng();
  const mp3 = makeTestMp3();

  const res = await request.post(`${CORE_URL}/api/v1/pictograms/upload`, {
    headers: authHeader(),
    multipart: {
      name: "pictogram-with-sound",
      organization_id: String(orgId),
      generate_sound: "false",
      image: {
        name: "test.png",
        mimeType: "image/png",
        buffer: png,
      },
      sound: {
        name: "test.mp3",
        mimeType: "audio/mpeg",
        buffer: mp3,
      },
    },
  });

  expect(res.status()).toBe(201);
  const body = await res.json();
  expect(body.name).toBe("pictogram-with-sound");
  expect(body.sound_url).toBeTruthy();
});

// ── Upload sound to existing pictogram ──────────────────────

test("upload sound to existing pictogram", async ({ request }) => {
  // First create a pictogram
  const createRes = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "needs-sound",
      image_url: "https://example.com/img.png",
      organization_id: orgId,
      generate_sound: false,
    },
  });
  expect(createRes.status()).toBe(201);
  const pictogram = await createRes.json();

  // Then upload sound to it
  const mp3 = makeTestMp3();
  const soundRes = await request.post(
    `${CORE_URL}/api/v1/pictograms/${pictogram.id}/sound`,
    {
      headers: authHeader(),
      multipart: {
        sound: {
          name: "voice.mp3",
          mimeType: "audio/mpeg",
          buffer: mp3,
        },
      },
    }
  );

  expect(soundRes.status()).toBe(200);
  const updated = await soundRes.json();
  expect(updated.sound_url).toBeTruthy();
});

// ── Search pictograms ───────────────────────────────────────

test("search pictograms returns results", async ({ request }) => {
  // Create a pictogram to search for
  const createRes = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "searchable-giraffe",
      image_url: "https://example.com/giraffe.png",
      organization_id: orgId,
      generate_sound: false,
    },
  });
  expect(createRes.status()).toBe(201);

  const res = await request.get(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    params: {
      search: "searchable-giraffe",
      limit: "10",
      organization_id: String(orgId),
    },
  });

  expect(res.status()).toBe(200);
  const body = await res.json();
  expect(body.items).toBeDefined();
  expect(body.count).toBeGreaterThanOrEqual(1);

  const match = body.items.find(
    (p: { name: string }) => p.name === "searchable-giraffe"
  );
  expect(match).toBeTruthy();
  expect(match.sound_url).toBeDefined();
});

// ── Get single pictogram ────────────────────────────────────

test("get pictogram by id", async ({ request }) => {
  const createRes = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "get-by-id-test",
      image_url: "https://example.com/test.png",
      organization_id: orgId,
      generate_sound: false,
    },
  });
  expect(createRes.status()).toBe(201);
  const created = await createRes.json();

  const res = await request.get(
    `${CORE_URL}/api/v1/pictograms/${created.id}`,
    { headers: jsonHeaders() }
  );

  expect(res.status()).toBe(200);
  const body = await res.json();
  expect(body.id).toBe(created.id);
  expect(body.name).toBe("get-by-id-test");
});

// ── Permission checks ───────────────────────────────────────

test("unauthenticated request is rejected", async ({ request }) => {
  const res = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: { "Content-Type": "application/json" },
    data: {
      name: "should-fail",
      image_url: "https://example.com/x.png",
    },
  });

  expect(res.status()).toBe(401);
});

// ── Validation ──────────────────────────────────────────────

test("create pictogram without image source fails", async ({ request }) => {
  const res = await request.post(`${CORE_URL}/api/v1/pictograms`, {
    headers: jsonHeaders(),
    data: {
      name: "no-image",
      organization_id: orgId,
    },
  });

  // Should fail validation — either 400 or 422
  expect([400, 422]).toContain(res.status());
});
