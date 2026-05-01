import { Badge } from "./ui/badge";
import { Progress } from "./ui/progress";

interface ProjectCardProps {
  title: string;
  progress: number;
  nextAction?: string;
  lastTouched: string;
  priority: "High" | "Medium" | "Low";
  onClick: () => void;
}

export function ProjectCard({
  title,
  progress,
  nextAction,
  lastTouched,
  priority,
  onClick,
}: ProjectCardProps) {
  const priorityColors = {
    High: "bg-red-500/10 text-red-400 border-red-500/20",
    Medium: "bg-yellow-500/10 text-yellow-400 border-yellow-500/20",
    Low: "bg-blue-500/10 text-blue-400 border-blue-500/20",
  };

  return (
    <div
      onClick={onClick}
      className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-5 hover:border-[#3a3d4a] transition-colors cursor-pointer"
    >
      <div className="flex items-start justify-between mb-3">
        <h3 className="text-foreground">{title}</h3>
        <Badge className={priorityColors[priority]} variant="outline">
          {priority}
        </Badge>
      </div>

      <Progress value={progress} className="mb-3 h-1.5" />

      <div className="space-y-2">
        {nextAction ? (
          <div className="flex items-start gap-2">
            <span className="text-blue-400 text-sm">→</span>
            <p className="text-sm text-foreground/80">{nextAction}</p>
          </div>
        ) : (
          <Badge className="bg-yellow-500/10 text-yellow-400 border-yellow-500/20" variant="outline">
            ⚠ Stalled
          </Badge>
        )}
        <p className="text-xs text-muted-foreground">Last touched: {lastTouched}</p>
      </div>
    </div>
  );
}
