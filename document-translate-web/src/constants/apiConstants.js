export const API_KEY = "202ecdadb21c49f2b5edc50fb7cd6660";
export const BASE_URL = "https://translator-apim-vwuif.azure-api.net/translation-service";

export const GET_LOGS_API = (date) => `${BASE_URL}/get_logs_by_date?date=${date}`;
export const GET_ALL_LOGS = `${BASE_URL}/get_all_logs`;
export const UPLOAD_API = `${BASE_URL}/upload_file`;
export const GET_PROMPTS_API = `${BASE_URL}/get_all_prompts`;