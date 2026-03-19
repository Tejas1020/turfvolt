// Phosphor icon keys for exercises (mapped to IconData in ExerciseModel)
class ExerciseIcons {
  static const String chest = 'chest';
  static const String back = 'back';
  static const String shoulders = 'shoulders';
  static const String arms = 'arms';
  static const String legs = 'legs';
  static const String core = 'core';
}

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
  {'id':'e1',  'name':'Incline Barbell Press',    'muscle':'Upper Chest',  'desc':'45° bench, full range',        'icon':'chest'},
  {'id':'e2',  'name':'Incline DB Press',          'muscle':'Upper Chest',  'desc':'Dumbbells, 30–45°',            'icon':'chest'},
  {'id':'e3',  'name':'High Cable Fly',            'muscle':'Upper Chest',  'desc':'Cable from high pulley',       'icon':'chest'},
  // Lower Chest
  {'id':'e4',  'name':'Decline Bench Press',       'muscle':'Lower Chest',  'desc':'Decline bench',                'icon':'chest'},
  {'id':'e5',  'name':'Chest Dips',                'muscle':'Lower Chest',  'desc':'Lean forward slightly',        'icon':'chest'},
  {'id':'e6',  'name':'Low Cable Fly',             'muscle':'Lower Chest',  'desc':'Cable from low pulley',        'icon':'chest'},
  // Back
  {'id':'e7',  'name':'Deadlift',                  'muscle':'Back',         'desc':'Hip hinge, neutral spine',     'icon':'back'},
  {'id':'e8',  'name':'Bent Over Row',             'muscle':'Back',         'desc':'Barbell, overhand grip',       'icon':'back'},
  {'id':'e9',  'name':'Lat Pulldown',              'muscle':'Back',         'desc':'Wide grip, full stretch',      'icon':'back'},
  {'id':'e10', 'name':'Seated Cable Row',          'muscle':'Back',         'desc':'Neutral grip',                 'icon':'back'},
  // Shoulders
  {'id':'e11', 'name':'Overhead Press',            'muscle':'Shoulders',    'desc':'Barbell, standing',            'icon':'shoulders'},
  {'id':'e12', 'name':'Lateral Raises',            'muscle':'Shoulders',    'desc':'DB, slight bend in elbow',     'icon':'shoulders'},
  {'id':'e13', 'name':'Face Pulls',                'muscle':'Shoulders',    'desc':'Cable, rope attachment',       'icon':'shoulders'},
  // Biceps
  {'id':'e14', 'name':'Barbell Curl',              'muscle':'Biceps',       'desc':'EZ bar or straight bar',       'icon':'arms'},
  {'id':'e15', 'name':'Incline DB Curl',           'muscle':'Biceps',       'desc':'Full stretch at bottom',       'icon':'arms'},
  {'id':'e16', 'name':'Hammer Curl',               'muscle':'Biceps',       'desc':'Neutral grip',                 'icon':'arms'},
  // Triceps
  {'id':'e17', 'name':'Tricep Pushdown',           'muscle':'Triceps',      'desc':'Cable, rope or bar',           'icon':'arms'},
  {'id':'e18', 'name':'Skull Crushers',            'muscle':'Triceps',      'desc':'EZ bar, bench',                'icon':'arms'},
  {'id':'e19', 'name':'Overhead Tricep Extension', 'muscle':'Triceps',      'desc':'DB or cable',                  'icon':'arms'},
  // Quads
  {'id':'e20', 'name':'Barbell Squat',             'muscle':'Quads',        'desc':'High bar, full depth',         'icon':'legs'},
  {'id':'e21', 'name':'Leg Press',                 'muscle':'Quads',        'desc':'Machine, feet shoulder width', 'icon':'legs'},
  // Hamstrings
  {'id':'e22', 'name':'Romanian Deadlift',         'muscle':'Hamstrings',   'desc':'Hip hinge, slight bend',       'icon':'legs'},
  {'id':'e23', 'name':'Leg Curl',                  'muscle':'Hamstrings',   'desc':'Lying or seated machine',      'icon':'legs'},
  // Glutes
  {'id':'e24', 'name':'Hip Thrust',                'muscle':'Glutes',       'desc':'Barbell, bench support',       'icon':'legs'},
  // Calves
  {'id':'e25', 'name':'Calf Raises',               'muscle':'Calves',       'desc':'Standing or seated',           'icon':'legs'},
  // Core
  {'id':'e26', 'name':'Plank',                     'muscle':'Core',         'desc':'Hold, neutral spine',          'icon':'core'},
  {'id':'e27', 'name':'Cable Crunch',              'muscle':'Core',         'desc':'Kneeling, rope',               'icon':'core'},
  {'id':'e28', 'name':'Hanging Leg Raise',         'muscle':'Core',         'desc':'Full hang, controlled',        'icon':'core'},
];

const List<String> muscleGroups = [
  'Upper Chest','Lower Chest','Back','Shoulders','Biceps',
  'Triceps','Forearms','Quads','Hamstrings','Glutes','Calves','Core','Full Body',
];
