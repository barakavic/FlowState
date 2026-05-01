import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Textarea } from "./ui/textarea";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";

interface Project {
  id: string;
  title: string;
  progress: number;
  nextAction?: string;
  lastTouched: string;
  priority: "High" | "Medium" | "Low";
  description?: string;
}

interface ProjectDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  project: Project | null;
  onSave: (project: Project) => void;
}

export function ProjectDialog({
  open,
  onOpenChange,
  project,
  onSave,
}: ProjectDialogProps) {
  if (!project) return null;

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-[#1a1d29] border-[#2a2d3a] max-w-2xl">
        <DialogHeader>
          <DialogTitle className="text-foreground">Edit Project</DialogTitle>
        </DialogHeader>

        <div className="space-y-4 py-4">
          <div className="space-y-2">
            <Label htmlFor="title">Project Title</Label>
            <Input
              id="title"
              defaultValue={project.title}
              className="bg-[#14161f] border-[#2a2d3a]"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="description">Description</Label>
            <Textarea
              id="description"
              defaultValue={project.description || ""}
              className="bg-[#14161f] border-[#2a2d3a] min-h-24"
            />
          </div>

          <div className="space-y-2">
            <Label htmlFor="nextAction">Next Action</Label>
            <Input
              id="nextAction"
              defaultValue={project.nextAction || ""}
              placeholder="What's the next concrete step?"
              className="bg-[#14161f] border-[#2a2d3a]"
            />
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div className="space-y-2">
              <Label htmlFor="progress">Progress (%)</Label>
              <Input
                id="progress"
                type="number"
                min="0"
                max="100"
                defaultValue={project.progress}
                className="bg-[#14161f] border-[#2a2d3a]"
              />
            </div>

            <div className="space-y-2">
              <Label>Priority</Label>
              <div className="flex gap-2 pt-2">
                {(["High", "Medium", "Low"] as const).map((priority) => (
                  <Badge
                    key={priority}
                    variant={project.priority === priority ? "default" : "outline"}
                    className="cursor-pointer"
                  >
                    {priority}
                  </Badge>
                ))}
              </div>
            </div>
          </div>

          <div className="flex justify-end gap-2 pt-4">
            <Button
              variant="outline"
              onClick={() => onOpenChange(false)}
              className="border-[#2a2d3a]"
            >
              Cancel
            </Button>
            <Button onClick={() => onOpenChange(false)} className="bg-blue-500 hover:bg-blue-600">
              Save Changes
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}
