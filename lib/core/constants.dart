class AppwriteConfig {
  // TurfVolt Appwrite project
  static const String endpoint = 'https://sgp.cloud.appwrite.io/v1';
  static const String projectId = '69b7aa29001c95b53929';

  // TurfVolt main database
  static const String databaseId = '69b7c3c1000d4392e618';

  // Collection IDs
  static const String colPlans     = 'plans';
  static const String colLogs      = 'logs';
  static const String colExercises = 'exercises';
  static const String colUsers     = 'users';
}

const List<Map<String, String>> builtInExercises = [
  // Upper Chest
  {'id':'e1',  'name':'Incline Barbell Press',    'muscle':'Upper Chest',  'desc':'45° bench, full range',        'icon':'💪'},
  {'id':'e2',  'name':'Incline DB Press',          'muscle':'Upper Chest',  'desc':'Dumbbells, 30–45°',            'icon':'💪'},
  {'id':'e3',  'name':'High Cable Fly',            'muscle':'Upper Chest',  'desc':'Cable from high pulley',       'icon':'💪'},
  // Lower Chest
  {'id':'e4',  'name':'Decline Bench Press',       'muscle':'Lower Chest',  'desc':'Decline bench',                'icon':'🏋'},
  {'id':'e5',  'name':'Chest Dips',                'muscle':'Lower Chest',  'desc':'Lean forward slightly',        'icon':'🏋'},
  {'id':'e6',  'name':'Low Cable Fly',             'muscle':'Lower Chest',  'desc':'Cable from low pulley',        'icon':'🏋'},
  // Back
  {'id':'e7',  'name':'Deadlift',                  'muscle':'Back',         'desc':'Hip hinge, neutral spine',     'icon':'⚡'},
  {'id':'e8',  'name':'Bent Over Row',             'muscle':'Back',         'desc':'Barbell, overhand grip',       'icon':'⚡'},
  {'id':'e9',  'name':'Lat Pulldown',              'muscle':'Back',         'desc':'Wide grip, full stretch',      'icon':'⚡'},
  {'id':'e10', 'name':'Seated Cable Row',          'muscle':'Back',         'desc':'Neutral grip',                 'icon':'⚡'},
  // Shoulders
  {'id':'e11', 'name':'Overhead Press',            'muscle':'Shoulders',    'desc':'Barbell, standing',            'icon':'🔥'},
  {'id':'e12', 'name':'Lateral Raises',            'muscle':'Shoulders',    'desc':'DB, slight bend in elbow',     'icon':'🔥'},
  {'id':'e13', 'name':'Face Pulls',                'muscle':'Shoulders',    'desc':'Cable, rope attachment',       'icon':'🔥'},
  // Biceps
  {'id':'e14', 'name':'Barbell Curl',              'muscle':'Biceps',       'desc':'EZ bar or straight bar',       'icon':'💙'},
  {'id':'e15', 'name':'Incline DB Curl',           'muscle':'Biceps',       'desc':'Full stretch at bottom',       'icon':'💙'},
  {'id':'e16', 'name':'Hammer Curl',               'muscle':'Biceps',       'desc':'Neutral grip',                 'icon':'💙'},
  // Triceps
  {'id':'e17', 'name':'Tricep Pushdown',           'muscle':'Triceps',      'desc':'Cable, rope or bar',           'icon':'🟠'},
  {'id':'e18', 'name':'Skull Crushers',            'muscle':'Triceps',      'desc':'EZ bar, bench',                'icon':'🟠'},
  {'id':'e19', 'name':'Overhead Tricep Extension', 'muscle':'Triceps',      'desc':'DB or cable',                  'icon':'🟠'},
  // Quads
  {'id':'e20', 'name':'Barbell Squat',             'muscle':'Quads',        'desc':'High bar, full depth',         'icon':'🦵'},
  {'id':'e21', 'name':'Leg Press',                 'muscle':'Quads',        'desc':'Machine, feet shoulder width', 'icon':'🦵'},
  // Hamstrings
  {'id':'e22', 'name':'Romanian Deadlift',         'muscle':'Hamstrings',   'desc':'Hip hinge, slight bend',       'icon':'🦵'},
  {'id':'e23', 'name':'Leg Curl',                  'muscle':'Hamstrings',   'desc':'Lying or seated machine',      'icon':'🦵'},
  // Glutes
  {'id':'e24', 'name':'Hip Thrust',                'muscle':'Glutes',       'desc':'Barbell, bench support',       'icon':'🦵'},
  // Calves
  {'id':'e25', 'name':'Calf Raises',               'muscle':'Calves',       'desc':'Standing or seated',           'icon':'🦵'},
  // Core
  {'id':'e26', 'name':'Plank',                     'muscle':'Core',         'desc':'Hold, neutral spine',          'icon':'⭐'},
  {'id':'e27', 'name':'Cable Crunch',              'muscle':'Core',         'desc':'Kneeling, rope',               'icon':'⭐'},
  {'id':'e28', 'name':'Hanging Leg Raise',         'muscle':'Core',         'desc':'Full hang, controlled',        'icon':'⭐'},
];

const List<String> muscleGroups = [
  'Upper Chest','Lower Chest','Back','Shoulders','Biceps',
  'Triceps','Forearms','Quads','Hamstrings','Glutes','Calves','Core','Full Body',
];
