import { useState } from "react";
import { Plus } from "lucide-react";
import { ExecutionUnit } from "./components/execution-unit";
import { SecondaryItem } from "./components/secondary-item";
import { SystemPanel } from "./components/system-panel";
import { PlanView } from "./components/plan-view";
import { CreateUnitDialog } from "./components/create-unit-dialog";
import { Button } from "./components/ui/button";

interface ExecutionUnitType {
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
}

export default function App() {
  const [focusedUnit] = useState<ExecutionUnitType>({
    id: "1",
    title: "Build Microservices Architecture",
    type: "Project",
    progress: 45,
    currentStep: 9,
    nextStep: "Implement API Gateway authentication layer",
    stepDeadline: "May 3, 2026",
    lastActivity: "2 hours ago",
    isOverdue: false,
    hoursUntilDeadline: 6,
    totalSteps: 18,
    completedSteps: 8,
  });

  const [secondaryUnits] = useState<ExecutionUnitType[]>([
    {
      id: "2",
      title: "Deep Work",
      type: "Book",
      progress: 60,
      currentStep: 6,
      nextStep: "Chapter 4: Drain the Shallows",
      stepDeadline: "May 20, 2026",
      lastActivity: "Yesterday",
      isOverdue: false,
      hoursUntilDeadline: 48,
      totalSteps: 8,
      completedSteps: 5,
    },
    {
      id: "3",
      title: "AWS Solutions Architect",
      type: "Course",
      progress: 25,
      currentStep: 4,
      nextStep: "Module 3: VPC and Networking",
      stepDeadline: "June 1, 2026",
      lastActivity: "3 days ago",
      isOverdue: false,
      hoursUntilDeadline: 120,
      totalSteps: 12,
      completedSteps: 3,
    },
    {
      id: "4",
      title: "Mobile App Redesign",
      type: "Project",
      progress: 15,
      currentStep: 4,
      nextStep: "Complete user research interviews",
      stepDeadline: "April 28, 2026",
      lastActivity: "5 days ago",
      isOverdue: true,
      hoursUntilDeadline: -72,
      totalSteps: 22,
      completedSteps: 3,
    },
  ]);

  const warnings = [
    { message: "2 steps overdue", severity: "high" as const },
    { message: "Mobile App Redesign: no progress in 5 days", severity: "high" as const },
    { message: "No progress today", severity: "medium" as const },
  ];

  const backlogItems = [
    "Learn Rust Programming",
    "Personal Website Redesign",
    "System Design Interview Prep",
    "Atomic Habits (Book)",
  ];

  const completedItems = [
    "Docker Fundamentals Course",
    "Design Patterns Book",
    "CI/CD Pipeline Setup",
  ];

  const [planViewOpen, setPlanViewOpen] = useState(false);
  const [createDialogOpen, setCreateDialogOpen] = useState(false);

  // Project milestones
  const projectMilestones = [
    {
      name: "Phase 1: Foundation",
      steps: [
        {
          id: "1",
          title: "Set up project repository and CI/CD",
          status: "done" as const,
          deadline: "Apr 20, 2026",
          allocatedHours: 4,
        },
        {
          id: "2",
          title: "Design microservices architecture diagram",
          status: "done" as const,
          deadline: "Apr 22, 2026",
          allocatedHours: 6,
        },
        {
          id: "3",
          title: "Implement API Gateway authentication layer",
          status: "pending" as const,
          deadline: "May 3, 2026",
          allocatedHours: 8,
        },
      ],
    },
    {
      name: "Phase 2: Core Services",
      steps: [
        {
          id: "4",
          title: "Build user service with auth endpoints",
          status: "pending" as const,
          deadline: "May 8, 2026",
          allocatedHours: 12,
        },
        {
          id: "5",
          title: "Implement data service with database layer",
          status: "pending" as const,
          deadline: "May 12, 2026",
          allocatedHours: 10,
        },
      ],
    },
  ];

  // Course modules with locked steps
  const courseMilestones = [
    {
      name: "Foundation",
      steps: [
        {
          id: "1",
          title: "Introduction to AWS Cloud",
          status: "done" as const,
          deadline: "Apr 15, 2026",
          allocatedHours: 2,
        },
        {
          id: "2",
          title: "IAM and Security Basics",
          status: "done" as const,
          deadline: "Apr 18, 2026",
          allocatedHours: 3,
        },
        {
          id: "3",
          title: "EC2 Fundamentals",
          status: "done" as const,
          deadline: "Apr 22, 2026",
          allocatedHours: 4,
        },
      ],
    },
    {
      name: "Networking",
      steps: [
        {
          id: "4",
          title: "VPC and Networking",
          status: "pending" as const,
          deadline: "May 2, 2026",
          allocatedHours: 5,
        },
        {
          id: "5",
          title: "Route 53 and DNS",
          status: "locked" as const,
          deadline: "May 6, 2026",
          allocatedHours: 3,
        },
        {
          id: "6",
          title: "CloudFront and CDN",
          status: "locked" as const,
          deadline: "May 10, 2026",
          allocatedHours: 4,
        },
      ],
    },
    {
      name: "Storage & Databases",
      steps: [
        {
          id: "7",
          title: "S3 Deep Dive",
          status: "locked" as const,
          deadline: "May 14, 2026",
          allocatedHours: 4,
        },
        {
          id: "8",
          title: "RDS and DynamoDB",
          status: "locked" as const,
          deadline: "May 18, 2026",
          allocatedHours: 5,
        },
      ],
    },
  ];

  const getSecondaryItemStatus = (unit: ExecutionUnitType) => {
    if (unit.isOverdue) return "overdue";
    const daysAgo = parseInt(unit.lastActivity.split(" ")[0]);
    if (isNaN(daysAgo)) return "active";
    return daysAgo > 2 ? "stale" : "active";
  };

  return (
    <div className="dark size-full flex flex-col bg-[#0f1117]">
      {/* Header */}
      <header className="border-b border-[#2a2d3a] bg-[#14161f] px-8 py-5 flex items-center justify-between shadow-lg">
        <div>
          <h1 className="text-2xl text-foreground">Flowstate</h1>
          <p className="text-xs text-muted-foreground mt-1">
            Structured Execution System
          </p>
        </div>
        <Button
          onClick={() => setCreateDialogOpen(true)}
          className="bg-blue-500 hover:bg-blue-600 px-6 py-5"
        >
          <Plus className="w-4 h-4 mr-2" />
          New Execution Unit
        </Button>
      </header>

      {/* Main Layout */}
      <div className="flex-1 flex overflow-hidden">
        {/* Main Content Area */}
        <main className="flex-1 overflow-y-auto p-8">
          <div className="max-w-5xl mx-auto space-y-10">
            {/* Primary Focus Unit */}
            <ExecutionUnit
              unit={focusedUnit}
              onMarkComplete={() => console.log("Mark complete")}
              onSwitchFocus={() => console.log("Switch focus")}
              onViewPlan={() => setPlanViewOpen(true)}
            />

            {/* Secondary Active Items - Low Emphasis */}
            <div>
              <h3 className="text-xs uppercase tracking-wider text-muted-foreground/60 mb-4">
                Other Units
              </h3>
              <div className="grid grid-cols-3 gap-4">
                {secondaryUnits.map((unit) => (
                  <SecondaryItem
                    key={unit.id}
                    title={unit.title}
                    type={unit.type}
                    progress={unit.progress}
                    status={getSecondaryItemStatus(unit)}
                    onClick={() => console.log("Switch to", unit.id)}
                  />
                ))}
              </div>
            </div>
          </div>
        </main>

        {/* Right System Panel */}
        <SystemPanel
          warnings={warnings}
          backlogItems={backlogItems}
          completedItems={completedItems}
        />
      </div>

      {/* Plan View Dialog */}
      <PlanView
        open={planViewOpen}
        onOpenChange={setPlanViewOpen}
        title={focusedUnit.title}
        type={focusedUnit.type}
        milestones={focusedUnit.type === "Course" ? courseMilestones : projectMilestones}
      />

      {/* Create Unit Dialog */}
      <CreateUnitDialog open={createDialogOpen} onOpenChange={setCreateDialogOpen} />
    </div>
  );
}