# Appwrite Collection Schema Setup

## Plans Collection

**Collection ID:** `plans`

### Required Attributes

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `name` | string | Yes | Plan name |
| `userId` | string | Yes | Reference to user who owns this plan |
| `createdAt` | datetime | Yes | Creation timestamp |
| `workoutDays` | array | Yes | Array of workout day objects (can be empty) |

### Optional Attributes

| Attribute | Type | Required | Description |
|-----------|------|----------|-------------|
| `description` | string | No | Plan description |
| `isTemplate` | boolean | No | If true, plan can be shared/reused |
| `updatedAt` | datetime | No | Last update timestamp |

### workoutDays Array Structure

Each item in the `workoutDays` array should have this structure:

```json
{
  "weekday": 0,
  "name": "Monday Workout",
  "exercises": [
    {
      "exerciseId": "e1",
      "exerciseName": "Incline Barbell Press",
      "muscleGroup": "Upper Chest",
      "sets": 3,
      "reps": 10,
      "weightKg": 50.0,
      "restSeconds": 60,
      "personalNotes": "",
      "prWeight": null,
      "lastPerformed": null
    }
  ],
  "notes": ""
}
```

### weekday Field Values

- `0` = Monday
- `1` = Tuesday
- `2` = Wednesday
- `3` = Thursday
- `4` = Friday
- `5` = Saturday
- `6` = Sunday

### Indexes to Create

1. **userId** - for querying user's plans
   - Type: Key
   - Attribute: userId

2. **userId_createdAt** - for ordering plans by date
   - Type: Key
   - Attributes: userId, createdAt (DESC)

### Permissions

Set the following permissions on the collection:

- **Create:** Users with authenticated session
- **Read:** Users who created the document (userId matches)
- **Update:** Users who created the document (userId matches)
- **Delete:** Users who created the document (userId matches)

---

## Setup Steps

### Via Appwrite Console

1. Go to your project → Database → Your database
2. Click on the `plans` collection (create if needed)
3. Add the attributes listed above
4. Create the indexes
5. Set permissions as described

### Via Appwrite CLI

```bash
# Login first
appwrite login

# Create collection (if not exists)
appwrite createCollection \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --name plans

# Add attributes
appwrite createStringAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key name \
  --required true \
  --length 255

appwrite createStringAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key userId \
  --required true \
  --length 255

appwrite createDatetimeAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key createdAt \
  --required true

appwrite createJsonAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key workoutDays \
  --required true

appwrite createStringAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key description \
  --required false \
  --length 1000

appwrite createBooleanAttribute \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key isTemplate \
  --required false

# Create indexes
appwrite createIndex \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key userId \
  --type key \
  --attributes userId

appwrite createIndex \
  --database-id YOUR_DATABASE_ID \
  --collection-id plans \
  --key userId_createdAt \
  --type key \
  --attributes userId createdAt

# Set permissions (via console or API)
```

---

## Migration from Legacy Schema

If you have existing plans with the old schema (`muscleGroup`, `exerciseIds` fields), they will be automatically converted when read. The `PlanModel.fromDoc()` factory handles both:

1. **New schema:** Uses `workoutDays` array
2. **Legacy schema:** Converts `muscleGroup` + `exerciseIds` to a default Monday workout day

For a clean migration, consider:
1. Export existing data
2. Transform to new format
3. Re-import with new schema
