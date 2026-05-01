import { Badge } from "./ui/badge";
import { AlertCircle, Clock } from "lucide-react";

interface SecondaryItemProps {
  title: string;
  type: "Project" | "Book" | "Course";
  progress: number;
  status: "active" | "stale" | "overdue";
  onClick: () => void;
}

export function SecondaryItem({
  title,
  type,
  progress,
  status,
  onClick,
}: SecondaryItemProps) {
  const typeColors = {
    Project: "bg-blue-500/10 text-blue-400/70 border-blue-500/20",
    Book: "bg-purple-500/10 text-purple-400/70 border-purple-500/20",
    Course: "bg-green-500/10 text-green-400/70 border-green-500/20",
  };

  const statusConfig = {
    active: { color: "text-blue-400/60", icon: null },
    stale: { color: "text-amber-400/70", icon: Clock },
    overdue: { color: "text-red-400/70", icon: AlertCircle },
  };

  const StatusIcon = statusConfig[status].icon;

  return (
    <div
      onClick={onClick}
      className="bg-[#1a1d29]/40 border border-[#2a2d3a]/50 rounded-lg p-4 hover:border-[#3a3d4a] hover:bg-[#1a1d29]/60 transition-colors cursor-pointer opacity-70 hover:opacity-100"
    >
      <div className="flex items-start justify-between mb-3">
        <div className="flex-1">
          <p className="text-sm text-foreground/70 mb-1.5">{title}</p>
          <Badge className={`${typeColors[type]} text-xs`} variant="outline">
            {type}
          </Badge>
        </div>
        {StatusIcon && (
          <StatusIcon className={`w-4 h-4 ${statusConfig[status].color}`} />
        )}
      </div>

      <div className="flex items-center justify-between">
        <div className="flex-1 bg-[#0f1117]/50 rounded-full h-1 mr-3">
          <div
            className="bg-blue-500/50 h-1 rounded-full"
            style={{ width: `${progress}%` }}
          />
        </div>
        <span className="text-xs text-muted-foreground/60">{progress}%</span>
      </div>
    </div>
  );
}
