const SERVER_URL = process.env.API_HOST_URL || "http://localhost:3000";

const getSiteConfigUrl = ({identity, site}) => {
  return `${SERVER_URL}/identities/${identity}/sites/${site}/site_config.json`;
};

export default async function getSiteConfig({identity, site}) {
  const headers = {
    "Content-Type": "application/json",
  };
  const response = await fetch(getSiteConfigUrl({identity, site}), {
    method: "GET",
    headers,
  });
  if (!response.ok) throw new Error(await response.text());
  return response.json();
}
