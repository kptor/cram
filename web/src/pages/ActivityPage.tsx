import { gql } from "@apollo/client";
import { useQuery, useMutation } from "@apollo/client/react";
import { useParams, useNavigate } from "react-router-dom";
import { useState } from "react";
import { Button } from "@/components/ui/button";

const GET_ASSIGNMENT = gql`
  query GetAssignment($id: ID!) {
    node(id: $id) {
      ... on Assignment {
        id
        status
        activity {
          id
          title
          parts {
            id
            position
            partable {
              ... on ActivityMultipleChoice {
                prompt
                choices {
                  id
                  label
                  correct
                  position
                }
              }
            }
          }
        }
      }
    }
  }
`;

const UPDATE_ASSIGNMENT = gql`
  mutation AssignmentUpdate($input: AssignmentUpdateInput!) {
    assignmentUpdate(input: $input) {
      assignment {
        id
        status
      }
      errors
    }
  }
`;

interface Choice {
  id: string;
  label: string;
  correct: boolean;
  position: number;
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

interface AssignmentData {
  node: {
    id: string;
    status: string;
    activity: {
      id: string;
      title: string;
      parts: Part[];
    };
  };
}

export default function ActivityPage() {
  const { assignmentId } = useParams();
  const navigate = useNavigate();
  const [currentPartIndex, setCurrentPartIndex] = useState(0);
  const [selectedChoiceId, setSelectedChoiceId] = useState<string | null>(null);
  const [revealed, setRevealed] = useState(false);

  const { data, loading, error } = useQuery<AssignmentData>(GET_ASSIGNMENT, {
    variables: { id: assignmentId },
  });

  const [updateAssignment] = useMutation(UPDATE_ASSIGNMENT);

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-muted-foreground">Loading...</p>
      </div>
    );
  }

  if (error || !data?.node) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <p className="text-destructive">Could not load activity</p>
      </div>
    );
  }

  const { activity } = data.node;
  const parts = [...activity.parts].sort((a, b) => a.position - b.position);
  const currentPart = parts[currentPartIndex];
  const isLastPart = currentPartIndex === parts.length - 1;
  const { prompt, choices } = currentPart.partable;

  const handleSelect = (choiceId: string) => {
    if (revealed) return;
    setSelectedChoiceId(choiceId);
  };

  const handleCheck = () => {
    setRevealed(true);

    // Mark as in_progress on first answer
    if (data.node.status === "NOT_STARTED") {
      updateAssignment({
        variables: { input: { id: assignmentId, status: "IN_PROGRESS" } },
      });
    }
  };

  const handleNext = () => {
    if (isLastPart) {
      updateAssignment({
        variables: { input: { id: assignmentId, status: "COMPLETED" } },
      }).then(() => navigate("/"));
      return;
    }

    setCurrentPartIndex((i) => i + 1);
    setSelectedChoiceId(null);
    setRevealed(false);
  };

  return (
    <div className="max-w-2xl mx-auto px-4 py-12">
      <div className="flex items-center justify-between mb-8">
        <h1 className="text-lg font-medium">{activity.title}</h1>
        <p className="text-sm text-muted-foreground">
          {currentPartIndex + 1} / {parts.length}
        </p>
      </div>

      <div className="space-y-6">
        <div className="prose prose-sm max-w-none">
          {prompt.split("\n").map((line, i) => {
            if (line.startsWith("# ")) {
              return (
                <h2 key={i} className="text-xl font-semibold mt-0">
                  {line.slice(2)}
                </h2>
              );
            }
            if (line.trim() === "") return <br key={i} />;
            return <p key={i} className="text-muted-foreground">{line}</p>;
          })}
        </div>

        <div className="space-y-2">
          {choices.map((choice) => {
            let className =
              "w-full text-left p-4 rounded-lg transition-colors ";

            if (!revealed) {
              className +=
                selectedChoiceId === choice.id
                  ? "bg-primary/10 ring-1 ring-primary"
                  : "bg-muted/50 hover:bg-muted";
            } else if (choice.correct) {
              className += "bg-green-500/10 ring-1 ring-green-500";
            } else if (selectedChoiceId === choice.id && !choice.correct) {
              className += "bg-destructive/10 ring-1 ring-destructive";
            } else {
              className += "bg-muted/30 opacity-60";
            }

            return (
              <button
                key={choice.id}
                className={className}
                onClick={() => handleSelect(choice.id)}
                disabled={revealed}
              >
                {choice.label}
              </button>
            );
          })}
        </div>

        <div className="flex justify-end">
          {!revealed ? (
            <Button
              onClick={handleCheck}
              disabled={!selectedChoiceId}
            >
              Check
            </Button>
          ) : (
            <Button onClick={handleNext}>
              {isLastPart ? "Finish" : "Next"}
            </Button>
          )}
        </div>
      </div>
    </div>
  );
}
