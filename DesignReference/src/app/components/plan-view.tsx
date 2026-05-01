import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Badge } from "./ui/badge";
import { CheckCircle2, Circle, AlertCircle, Lock } from "lucide-react";

interface Step {
  id: string;
  title: string;
  status: "pending" | "done" | "locked";
  deadline: string;
  allocatedHours: number;
  isOverdue?: boolean;
}

interface Milestone {
  name: string;
  steps: Step[];
}

interface PlanViewProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  title: string;
  type: "Project" | "Book" | "Course";
  milestones: Milestone[];
}

export function PlanView({
  open,
  onOpenChange,
  title,
  type,
  milestones,
}: PlanViewProps) {
  const groupLabel =
    type === "Project" ? "Milestones" : type === "Book" ? "Chapters" : "Modules";

  const enforceSequence = type === "Course";

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-[#14161f] border-[#2a2d3a] max-w-4xl max-h-[80vh] overflow-hidden flex flex-col">
        <DialogHeader>
          <DialogTitle className="text-foreground text-xl">{title}</DialogTitle>
          <div className="flex items-center gap-2">
            <p className="text-sm text-muted-foreground">{groupLabel}</p>
            {enforceSequence && (
              <Badge className="bg-green-500/10 text-green-400 border-green-500/30 text-xs">
                Sequential
              </Badge>
            )}
          </div>
        </DialogHeader>

        <div className="flex-1 overflow-y-auto pr-2 space-y-6 py-2">
          {milestones.map((milestone, mIndex) => (
            <div key={mIndex}>
              <h3 className="text-foreground mb-3 sticky top-0 bg-[#14161f] py-2 z-10">
                {milestone.name}
              </h3>

              <div className="space-y-2">
                {milestone.steps.map((step, sIndex) => {
                  const isLocked = step.status === "locked";
                  const Icon =
                    step.status === "done"
                      ? CheckCircle2
                      : isLocked
                      ? Lock
                      : step.isOverdue
                      ? AlertCircle
                      : Circle;

                  const iconColor =
                    step.status === "done"
                      ? "text-green-400"
                      : isLocked
                      ? "text-muted-foreground/40"
                      : step.isOverdue
                      ? "text-red-400"
                      : "text-blue-400";

                  return (
                    <div
                      key={step.id}
                      className={`flex items-start gap-3 p-4 rounded-lg border transition-colors ${
                        isLocked
                          ? "bg-[#0f1117]/50 border-[#2a2d3a]/30 opacity-40"
                          : step.isOverdue
                          ? "bg-red-500/5 border-red-500/30"
                          : step.status === "done"
                          ? "bg-[#0f1117] border-[#2a2d3a] opacity-50"
                          : "bg-[#1a1d29] border-[#2a2d3a] hover:border-[#3a3d4a]"
                      }`}
                    >
                      <Icon className={`w-5 h-5 ${iconColor} flex-shrink-0 mt-0.5`} />

                      <div className="flex-1">
                        <p
                          className={`text-sm ${
                            step.status === "done"
                              ? "text-foreground/50 line-through"
                              : isLocked
                              ? "text-foreground/30"
                              : "text-foreground"
                          }`}
                        >
                          {step.title}
                        </p>

                        {!isLocked && (
                          <div className="flex items-center gap-4 mt-2 flex-wrap">
                            <span className="text-xs text-muted-foreground">
                              Due: {step.deadline}
                            </span>
                            <span className="text-xs text-muted-foreground">
                              {step.allocatedHours}h allocated
                            </span>
                            {step.isOverdue && (
                              <Badge className="bg-red-500/20 text-red-400 border-red-500/40 text-xs">
                                Overdue
                              </Badge>
                            )}
                          </div>
                        )}

                        {isLocked && (
                          <p className="text-xs text-muted-foreground/50 mt-1">
                            Complete previous steps to unlock
                          </p>
                        )}
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          ))}
        </div>
      </DialogContent>
    </Dialog>
  );
}
