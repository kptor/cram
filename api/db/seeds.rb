dev_user = User.find_or_create_by!(email: "keagan@mindjoy.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
puts "Dev user: #{dev_user.email} (#{dev_user.previously_new_record? ? 'created' : 'already existed'})"

def seed_activity(user:, title:, description:, questions:)
  activity = Activity.find_or_create_by!(title: title, user: user) do |a|
    a.description = description
  end

  if activity.parts.empty?
    questions.each_with_index do |q, i|
      mc = Activity::MultipleChoice.create!(prompt: q[:prompt])
      Activity::Part.create!(activity: activity, partable: mc, position: i)
      q[:choices].each_with_index do |c, j|
        Activity::MultipleChoice::Choice.create!(
          multiple_choice: mc,
          label: c[:label],
          correct: c[:correct] || false,
          position: j
        )
      end
    end
    puts "  Created '#{title}' with #{questions.length} questions"
  else
    puts "  '#{title}' already exists"
  end

  Assignment.find_or_create_by!(activity: activity, user: user)
  activity
end

# --- Sample activity ---
seed_activity(
  user: dev_user,
  title: "Introduction to Photosynthesis",
  description: "Learn how plants convert sunlight into energy",
  questions: [
    {
      prompt: "# What is Photosynthesis?\n\nPhotosynthesis is the process by which green plants convert sunlight into chemical energy. What best describes this process?",
      choices: [
        { label: "A process in animals", correct: false },
        { label: "Converting sunlight to chemical energy", correct: true },
        { label: "A type of respiration", correct: false }
      ]
    },
    {
      prompt: "# The Light Reactions\n\nThe light-dependent reactions occur in the thylakoid membranes of chloroplasts. Where do these reactions take place?",
      choices: [
        { label: "Mitochondria", correct: false },
        { label: "Thylakoid membranes", correct: true },
        { label: "Cell wall", correct: false }
      ]
    }
  ]
)

# --- Grade 11 Term 1 CAPS: Mathematics ---
seed_activity(
  user: dev_user,
  title: "Gr 11 Maths: Exponents & Surds",
  description: "CAPS Term 1 — Simplify expressions with exponents and surds",
  questions: [
    {
      prompt: "# Exponent Laws\n\nSimplify: 2³ × 2⁴",
      choices: [
        { label: "2⁷ = 128", correct: true },
        { label: "2¹² = 4096", correct: false },
        { label: "4⁷", correct: false },
        { label: "2³ = 8", correct: false }
      ]
    },
    {
      prompt: "# Negative Exponents\n\nWhat is 5⁻² equal to?",
      choices: [
        { label: "−25", correct: false },
        { label: "1/25", correct: true },
        { label: "−10", correct: false },
        { label: "0.5", correct: false }
      ]
    },
    {
      prompt: "# Simplifying Surds\n\nSimplify: √50",
      choices: [
        { label: "5√2", correct: true },
        { label: "25√2", correct: false },
        { label: "√25 + √25", correct: false },
        { label: "10√5", correct: false }
      ]
    },
    {
      prompt: "# Rationalising the Denominator\n\nRationalise: 1 / √3",
      choices: [
        { label: "√3 / 3", correct: true },
        { label: "3 / √3", correct: false },
        { label: "1 / 3", correct: false },
        { label: "√3", correct: false }
      ]
    },
    {
      prompt: "# Exponential Equations\n\nSolve for x: 3ˣ = 81",
      choices: [
        { label: "x = 3", correct: false },
        { label: "x = 4", correct: true },
        { label: "x = 27", correct: false },
        { label: "x = 5", correct: false }
      ]
    }
  ]
)

seed_activity(
  user: dev_user,
  title: "Gr 11 Maths: Equations & Inequalities",
  description: "CAPS Term 1 — Quadratics, simultaneous equations, and inequalities",
  questions: [
    {
      prompt: "# Quadratic Equations\n\nSolve: x² − 5x + 6 = 0",
      choices: [
        { label: "x = 2 or x = 3", correct: true },
        { label: "x = −2 or x = −3", correct: false },
        { label: "x = 1 or x = 6", correct: false },
        { label: "x = 5 or x = 1", correct: false }
      ]
    },
    {
      prompt: "# The Discriminant\n\nFor ax² + bx + c = 0, the discriminant Δ = b² − 4ac. If Δ < 0, then:",
      choices: [
        { label: "There are two real roots", correct: false },
        { label: "There is one repeated real root", correct: false },
        { label: "There are no real roots", correct: true },
        { label: "There are two positive roots", correct: false }
      ]
    },
    {
      prompt: "# Simultaneous Equations\n\nSolve: y = 2x + 1 and y = x² − 2. What are the x-values?",
      choices: [
        { label: "x = 3 or x = −1", correct: true },
        { label: "x = 1 or x = −3", correct: false },
        { label: "x = 2 or x = −2", correct: false },
        { label: "x = 0 or x = 3", correct: false }
      ]
    },
    {
      prompt: "# Quadratic Inequality\n\nSolve: x² − 4 < 0",
      choices: [
        { label: "x < −2 or x > 2", correct: false },
        { label: "−2 < x < 2", correct: true },
        { label: "x < 2", correct: false },
        { label: "x > −2", correct: false }
      ]
    },
    {
      prompt: "# Completing the Square\n\nExpress x² + 6x + 5 in the form (x + p)² + q",
      choices: [
        { label: "(x + 3)² − 4", correct: true },
        { label: "(x + 3)² + 4", correct: false },
        { label: "(x + 6)² − 31", correct: false },
        { label: "(x + 2)² + 1", correct: false }
      ]
    }
  ]
)

seed_activity(
  user: dev_user,
  title: "Gr 11 Maths: Number Patterns",
  description: "CAPS Term 1 — Quadratic sequences and general terms",
  questions: [
    {
      prompt: "# Linear vs Quadratic\n\nThe sequence 2, 6, 12, 20, 30, ... has second differences that are constant. This is a:",
      choices: [
        { label: "Linear sequence", correct: false },
        { label: "Quadratic sequence", correct: true },
        { label: "Geometric sequence", correct: false },
        { label: "Arithmetic sequence", correct: false }
      ]
    },
    {
      prompt: "# Second Differences\n\nFor the sequence 1, 4, 9, 16, 25, ... the first differences are 3, 5, 7, 9. What is the constant second difference?",
      choices: [
        { label: "1", correct: false },
        { label: "2", correct: true },
        { label: "3", correct: false },
        { label: "4", correct: false }
      ]
    },
    {
      prompt: "# General Term\n\nThe general term of the sequence 2, 5, 10, 17, 26, ... is Tₙ = n² + 1. What is T₁₀?",
      choices: [
        { label: "100", correct: false },
        { label: "101", correct: true },
        { label: "91", correct: false },
        { label: "110", correct: false }
      ]
    }
  ]
)

# --- Grade 11 Term 1 CAPS: Physical Sciences ---
seed_activity(
  user: dev_user,
  title: "Gr 11 Physics: Vectors in 2D",
  description: "CAPS Term 1 — Vector addition, components, and resultants",
  questions: [
    {
      prompt: "# Scalar vs Vector\n\nWhich of the following is a vector quantity?",
      choices: [
        { label: "Speed", correct: false },
        { label: "Distance", correct: false },
        { label: "Displacement", correct: true },
        { label: "Temperature", correct: false }
      ]
    },
    {
      prompt: "# Resultant Vector\n\nTwo forces of 3 N and 4 N act at right angles to each other. What is the magnitude of the resultant?",
      choices: [
        { label: "7 N", correct: false },
        { label: "5 N", correct: true },
        { label: "1 N", correct: false },
        { label: "12 N", correct: false }
      ]
    },
    {
      prompt: "# Vector Components\n\nA force of 10 N acts at 30° to the horizontal. What is the horizontal component?",
      choices: [
        { label: "10 sin 30° = 5 N", correct: false },
        { label: "10 cos 30° = 8.66 N", correct: true },
        { label: "10 tan 30° = 5.77 N", correct: false },
        { label: "10 / cos 30° = 11.55 N", correct: false }
      ]
    },
    {
      prompt: "# Head-to-Tail Method\n\nWhen adding vectors using the head-to-tail method, the resultant is drawn from:",
      choices: [
        { label: "The head of the first vector to the tail of the last vector", correct: false },
        { label: "The tail of the first vector to the head of the last vector", correct: true },
        { label: "The midpoint of each vector", correct: false },
        { label: "Parallel to the largest vector", correct: false }
      ]
    }
  ]
)

seed_activity(
  user: dev_user,
  title: "Gr 11 Physics: Newton's Laws",
  description: "CAPS Term 1 — Newton's three laws of motion and applications",
  questions: [
    {
      prompt: "# Newton's First Law\n\nAn object remains at rest or in uniform motion in a straight line unless acted upon by a net external force. This is known as the law of:",
      choices: [
        { label: "Acceleration", correct: false },
        { label: "Inertia", correct: true },
        { label: "Action-reaction", correct: false },
        { label: "Gravity", correct: false }
      ]
    },
    {
      prompt: "# Newton's Second Law\n\nA net force of 20 N acts on an object of mass 4 kg. What is its acceleration?",
      choices: [
        { label: "80 m·s⁻²", correct: false },
        { label: "5 m·s⁻²", correct: true },
        { label: "0.2 m·s⁻²", correct: false },
        { label: "24 m·s⁻²", correct: false }
      ]
    },
    {
      prompt: "# Newton's Third Law\n\nWhen you push against a wall, the wall pushes back with:",
      choices: [
        { label: "A smaller force", correct: false },
        { label: "A larger force", correct: false },
        { label: "An equal and opposite force", correct: true },
        { label: "No force at all", correct: false }
      ]
    },
    {
      prompt: "# Free Body Diagrams\n\nA book rests on a table. Which pair of forces are the Newton's Third Law pair?",
      choices: [
        { label: "Weight of book and normal force from table", correct: false },
        { label: "Weight of book and gravitational pull of book on Earth", correct: true },
        { label: "Normal force and friction", correct: false },
        { label: "Weight and air resistance", correct: false }
      ]
    },
    {
      prompt: "# Friction\n\nAn object is being pulled along a rough surface at constant velocity. The applied force is 15 N. What is the frictional force?",
      choices: [
        { label: "0 N", correct: false },
        { label: "Less than 15 N", correct: false },
        { label: "15 N", correct: true },
        { label: "Greater than 15 N", correct: false }
      ]
    }
  ]
)

# --- Grade 11 Term 1 CAPS: Life Sciences ---
seed_activity(
  user: dev_user,
  title: "Gr 11 Life Sciences: Biodiversity & Classification",
  description: "CAPS Term 1 — Taxonomy, classification systems, and biodiversity",
  questions: [
    {
      prompt: "# Levels of Classification\n\nWhat is the correct order from broadest to most specific?",
      choices: [
        { label: "Kingdom, Phylum, Class, Order, Family, Genus, Species", correct: true },
        { label: "Species, Genus, Family, Order, Class, Phylum, Kingdom", correct: false },
        { label: "Kingdom, Class, Phylum, Order, Family, Genus, Species", correct: false },
        { label: "Domain, Species, Kingdom, Phylum, Class, Order", correct: false }
      ]
    },
    {
      prompt: "# Binomial Nomenclature\n\nThe scientific name *Homo sapiens* follows binomial nomenclature. Which part indicates the genus?",
      choices: [
        { label: "sapiens", correct: false },
        { label: "Homo", correct: true },
        { label: "Both together", correct: false },
        { label: "Neither — it indicates the family", correct: false }
      ]
    },
    {
      prompt: "# Five Kingdom System\n\nWhich kingdom contains organisms that are unicellular, prokaryotic, and lack a nucleus?",
      choices: [
        { label: "Protista", correct: false },
        { label: "Fungi", correct: false },
        { label: "Monera (Bacteria)", correct: true },
        { label: "Plantae", correct: false }
      ]
    },
    {
      prompt: "# Biodiversity\n\nSouth Africa is considered a megadiverse country. What does this mean?",
      choices: [
        { label: "It has the largest land area in Africa", correct: false },
        { label: "It contains an exceptionally high number of species", correct: true },
        { label: "It has the most national parks", correct: false },
        { label: "It has no endangered species", correct: false }
      ]
    },
    {
      prompt: "# Dichotomous Keys\n\nA dichotomous key is used to:",
      choices: [
        { label: "Count the number of species in an area", correct: false },
        { label: "Identify organisms using a series of paired statements", correct: true },
        { label: "Classify organisms by colour only", correct: false },
        { label: "Determine the age of a fossil", correct: false }
      ]
    }
  ]
)

seed_activity(
  user: dev_user,
  title: "Gr 11 Chemistry: Atomic Structure & IMFs",
  description: "CAPS Term 1 — Atomic models, electron configuration, and intermolecular forces",
  questions: [
    {
      prompt: "# Electron Configuration\n\nWhat is the electron configuration of Calcium (Ca, Z=20)?",
      choices: [
        { label: "1s² 2s² 2p⁶ 3s² 3p⁶ 4s²", correct: true },
        { label: "1s² 2s² 2p⁶ 3s² 3p⁶ 3d²", correct: false },
        { label: "1s² 2s² 2p⁶ 3s² 3p⁴ 4s⁴", correct: false },
        { label: "1s² 2s² 2p⁶ 3s² 3p⁸", correct: false }
      ]
    },
    {
      prompt: "# Intermolecular Forces\n\nWhich intermolecular force is the strongest?",
      choices: [
        { label: "London dispersion forces", correct: false },
        { label: "Dipole-dipole forces", correct: false },
        { label: "Hydrogen bonds", correct: true },
        { label: "Ion-ion interactions are intermolecular", correct: false }
      ]
    },
    {
      prompt: "# Boiling Points\n\nWater (H₂O) has an unusually high boiling point for its molecular mass because of:",
      choices: [
        { label: "London forces between molecules", correct: false },
        { label: "Strong hydrogen bonds between molecules", correct: true },
        { label: "Strong covalent bonds within molecules", correct: false },
        { label: "Metallic bonding", correct: false }
      ]
    },
    {
      prompt: "# Electronegativity\n\nAs you move from left to right across a period, electronegativity generally:",
      choices: [
        { label: "Decreases", correct: false },
        { label: "Stays the same", correct: false },
        { label: "Increases", correct: true },
        { label: "Fluctuates randomly", correct: false }
      ]
    },
    {
      prompt: "# Molecular Polarity\n\nCO₂ is a non-polar molecule even though it has polar bonds. This is because:",
      choices: [
        { label: "Carbon is not electronegative", correct: false },
        { label: "The molecule is linear and the dipoles cancel out", correct: true },
        { label: "Oxygen atoms are too far apart", correct: false },
        { label: "It only has London forces", correct: false }
      ]
    }
  ]
)

puts "\nSeeding complete."
puts "  Users: #{User.count}"
puts "  Activities: #{Activity.count}"
puts "  Assignments: #{Assignment.count}"
puts "  Total questions: #{Activity::MultipleChoice.count}"
