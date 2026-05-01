import { Badge } from "./ui/badge";
import { Progress } from "./ui/progress";
import { Button } from "./ui/button";
import { CheckCircle, List, Repeat, AlertTriangle, Clock } from "lucide-react";

interface Step {
  id: string;
  title: string;
  status: "pending" | "done";
  deadline: string;
  allocatedHours: number;
  isOverdue?: boolean;
}

interface ExecutionUnit {
  id: string;
  title: string;
  type: "Project" | "Book" | "Course";
  progress: number;
  currentStep: number;
  nextStep: string;
  stepDeadline: string;
  lastActivity: string;
  isOverdue: boolean;
  hoursUntilDeadline?: number;
  totalSteps: number;
  completedSteps: number;
  steps?: Step[];
}

interface ExecutionUnitProps {
  unit: ExecutionUnit;
  onMarkComplete: () => void;
  onSwitchFocus: () => void;
  onViewPlan: () => void;
}

export function ExecutionUnit({
  unit,
  onMarkComplete,
  onSwitchFocus,
  onViewPlan,
}: ExecutionUnitProps) {
  const typeColors = {
    Project: "bg-blue-500/20 text-blue-400 border-blue-500/40",
    Book: "bg-purple-500/20 text-purple-400 border-purple-500/40",
    Course: "bg-green-500/20 text-green-400 border-green-500/40",
  };

  const getTimePressure = () => {
    if (unit.isOverdue) {
      const hoursOverdue = Math.abs(unit.hoursUntilDeadline || 0);
      const daysOverdue = Math.floor(hoursOverdue / 24);
      return {
        text: daysOverdue > 0
          ? `⚠ Overdue by ${daysOverdue} day${daysOverdue > 1 ? 's' : ''}`
          : `⚠ Overdue by ${hoursOverdue} hour${hoursOverdue > 1 ? 's' : ''}`,
        className: "text-red-400 bg-red-500/10 border-red-500/30",
        icon: AlertTriangle,
      };
    }

    const hours = unit.hoursUntilDeadline || 0;
    if (hours < 24) {
      return {
        text: `⏱ Due in ${hours} hour${hours !== 1 ? 's' : ''}`,
        className: "text-amber-400 bg-amber-500/10 border-amber-500/30",
        icon: Clock,
      };
    }

    const days = Math.ceil(hours / 24);
    return {
      text: `Due in ${days} day${days > 1 ? 's' : ''}`,
      className: "text-blue-400 bg-blue-500/10 border-blue-500/30",
      icon: Clock,
    };
  };

  const timePressure = getTimePressure();
  const TimePressureIcon = timePressure.icon;

  return (
    <div className="bg-[#14161f] border-2 border-[#2a2d3a] rounded-xl p-8 shadow-2xl">
      {/* Header */}
      <div className="flex items-start justify-between mb-6">
        <div className="flex items-center gap-3">
          <h1 className="text-2xl text-foreground">{unit.title}</h1>
          <Badge className={typeColors[unit.type]} variant="outline">
            {unit.type}
          </Badge>
        </div>
        <div className="text-right">
          <p className="text-xs text-muted-foreground">
            Step {unit.currentStep} of {unit.totalSteps}
          </p>
        </div>
      </div>

      {/* Progress */}
      <div className="mb-8">
        <Progress value={unit.progress} className="h-2 mb-2" />
        <p className="text-xs text-muted-foreground">
          {unit.completedSteps} completed • {unit.totalSteps - unit.completedSteps} remaining
        </p>
      </div>

      {/* DO THIS NEXT - Highly Prominent */}
      <div className="bg-gradient-to-br from-blue-500/20 to-blue-600/10 border-2 border-blue-500/40 rounded-xl p-8 mb-6 shadow-lg">
        <p className="text-xs tracking-wider text-blue-400/80 mb-3">
          DO THIS NEXT
        </p>
        <p className="text-2xl text-foreground mb-6 leading-tight">
          {unit.nextStep}
        </p>

        {/* Time Pressure - Very Prominent */}
        <div className={`flex items-center gap-2 px-4 py-2 rounded-lg border inline-flex ${timePressure.className}`}>
          {TimePressureIcon && <TimePressureIcon className="w-4 h-4" />}
          <span className="text-sm font-medium">{timePressure.text}</span>
        </div>
      </div>

      {/* Secondary Info */}
      <div className="mb-6 text-xs text-muted-foreground">
        Last activity: {unit.lastActivity}
      </div>

      {/* Actions */}
      <div className="flex items-center gap-3">
        <Button
          onClick={onMarkComplete}
          className="bg-blue-500 hover:bg-blue-600 text-base px-6 py-6 flex-1"
        >
          <CheckCircle className="w-5 h-5 mr-2" />
          Complete Step
        </Button>
        <Button
          onClick={onViewPlan}
          variant="outline"
          className="border-[#2a2d3a] hover:bg-[#1a1d29] px-6 py-6"
        >
          <List className="w-4 h-4 mr-2" />
          View Execution Plan
        </Button>
        <Button
          onClick={onSwitchFocus}
          variant="outline"
          className="border-[#2a2d3a] hover:bg-[#1a1d29] px-6 py-6"
        >
          <Repeat className="w-4 h-4 mr-2" />
          Switch Focus
        </Button>
      </div>
    </div>
  );
}
