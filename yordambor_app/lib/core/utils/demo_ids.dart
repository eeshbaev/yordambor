/// Demo feed entities use non-UUID ids (`demo-…`). Supabase expects UUIDs.
bool isDemoFeedId(String id) => id.startsWith('demo-');

bool isSimulatedKelishuvId(String id) => id.startsWith('demo-kelishuv-');
