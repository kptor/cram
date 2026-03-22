import { gql } from "@apollo/client";
import { useQuery } from "@apollo/client/react";
import { useNavigate } from "react-router-dom";
import { useEffect } from "react";
import { Button } from "@/components/ui/button";

const MY_ASSIGNMENTS = gql`
  query MyAssignments {
    myAssignments {
      nodes {
        id
        status
        activity {
          id
          title
          description
          parts {
            id
          }
        }
      }
    }
  }
`;

interface Choice {
  label: string;
  correct: boolean;
}

interface MultipleChoice {
  prompt: string;
  choices: Choice[];
}

interface Part {
  id: string;
  position: number;
  partable: MultipleChoice;
}

interface Activity {
  id: string;
  title: string;
  description: string | null;
  parts: Part[];
}

interface Assignment {
  id: string;
  status: string;
  activity: Activity;
}

interface MyAssignmentsData {
  myAssignments: {
    nodes: Assignment[];
  };
}

const STATUS_LABELS: Record<string, string> = {
  NOT_STARTED: "Start",
  IN_PROGRESS: "Continue",
  COMPLETED: "Review",
};

export default function HomePage() {
  const navigate = useNavigate();
  const { data, loading, error } = useQuery<MyAssignmentsData>(MY_ASSIGNMENTS);

  useEffect(() => {
    if (error?.message?.includes("sign in")) {
      navigate("/login");
    }
  }, [error, navigate]);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-muted-foreground">Loading...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-destructive">Something went wrong</p>
      </div>
    );
  }

  const assignments = data?.myAssignments.nodes ?? [];

  return (
    <div className="max-w-2xl mx-auto px-4 py-12">
      <h1 className="text-3xl font-bold mb-8">cram</h1>

      {assignments.length === 0 ? (
        <p className="text-muted-foreground">No activities assigned yet.</p>
      ) : (
        <div className="space-y-3">
          {assignments.map((assignment) => (
            <div
              key={assignment.id}
              className="flex items-center justify-between p-4 rounded-lg bg-muted/50"
            >
              <div className="space-y-1">
                <h2 className="font-medium">{assignment.activity.title}</h2>
                {assignment.activity.description && (
                  <p className="text-sm text-muted-foreground">
                    {assignment.activity.description}
                  </p>
                )}
                <p className="text-xs text-muted-foreground">
                  {assignment.activity.parts.length} questions
                </p>
              </div>
              <Button
                variant="outline"
                size="sm"
                onClick={() => navigate(`/activity/${assignment.id}`)}
              >
                {STATUS_LABELS[assignment.status] ?? "Start"}
              </Button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
