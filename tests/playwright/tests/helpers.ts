import { APIRequestContext } from "@playwright/test";

const CORE_URL = process.env.CORE_URL ?? "http://localhost:8000";

const TEST_USER = {
  username: "e2e_pictogram",
  password: "E2eTestPass99",
  email: "e2e_picto@test.com",
  first_name: "E2E",
  last_name: "Pictogram",
};

/** Register (idempotent) and login, returning the JWT access token. */
export async function getAuthToken(
  request: APIRequestContext
): Promise<string> {
  // Register — ignore 409 conflict
  await request.post(`${CORE_URL}/api/v1/auth/register`, {
    data: TEST_USER,
  });

  const loginRes = await request.post(`${CORE_URL}/api/v1/token/pair`, {
    data: { username: TEST_USER.username, password: TEST_USER.password },
  });
  const body = await loginRes.json();
  return body.access as string;
}

/** Create an org and re-login so the token includes org_roles. */
export async function setupOrg(
  request: APIRequestContext,
  token: string
): Promise<{ orgId: number; token: string }> {
  const orgRes = await request.post(`${CORE_URL}/api/v1/organizations`, {
    headers: { Authorization: `Bearer ${token}` },
    data: { name: `E2E Picto Org ${Date.now()}` },
  });
  const org = await orgRes.json();

  // Re-login for updated org_roles
  const newToken = await getAuthToken(request);
  return { orgId: org.id, token: newToken };
}

/** Delete org for cleanup. */
export async function deleteOrg(
  request: APIRequestContext,
  orgId: number,
  token: string
): Promise<void> {
  await request.delete(`${CORE_URL}/api/v1/organizations/${orgId}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
}

/** Create a minimal 1x1 PNG as a Buffer. */
export function makeTestPng(): Buffer {
  // Minimal valid 1x1 red PNG
  return Buffer.from(
    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8/5+hHgAHggJ/PchI7wAAAABJRU5ErkJggg==",
    "base64"
  );
}

/** Create a minimal MP3 buffer (valid header). */
export function makeTestMp3(): Buffer {
  // Minimal MP3 frame: sync word 0xFFEB + padding
  const buf = Buffer.alloc(417);
  buf[0] = 0xff;
  buf[1] = 0xfb;
  buf[2] = 0x90;
  buf[3] = 0x00;
  return buf;
}
