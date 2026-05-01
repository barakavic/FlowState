import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Textarea } from "./ui/textarea";
import { Upload, Plus } from "lucide-react";
import { useState } from "react";

interface CreateUnitDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
}

export function CreateUnitDialog({ open, onOpenChange }: CreateUnitDialogProps) {
  const [selectedType, setSelectedType] = useState<"Project" | "Book" | "Course" | null>(null);

  const resetAndClose = () => {
    setSelectedType(null);
    onOpenChange(false);
  };

  return (
    <Dialog open={open} onOpenChange={resetAndClose}>
      <DialogContent className="bg-[#14161f] border-[#2a2d3a] max-w-2xl">
        <DialogHeader>
          <DialogTitle className="text-foreground">Create Execution Unit</DialogTitle>
        </DialogHeader>

        {!selectedType ? (
          <div className="grid grid-cols-3 gap-4 py-6">
            <button
              onClick={() => setSelectedType("Project")}
              className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-6 hover:border-blue-500/50 hover:bg-blue-500/5 transition-colors group"
            >
              <div className="text-4xl mb-3 group-hover:scale-110 transition-transform">
                📋
              </div>
              <h3 className="text-foreground mb-1">Project</h3>
              <p className="text-xs text-muted-foreground">
                Upload roadmap or define milestones
              </p>
            </button>

            <button
              onClick={() => setSelectedType("Book")}
              className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-6 hover:border-purple-500/50 hover:bg-purple-500/5 transition-colors group"
            >
              <div className="text-4xl mb-3 group-hover:scale-110 transition-transform">
                📚
              </div>
              <h3 className="text-foreground mb-1">Book</h3>
              <p className="text-xs text-muted-foreground">
                Upload PDF or enter chapters
              </p>
            </button>

            <button
              onClick={() => setSelectedType("Course")}
              className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-6 hover:border-green-500/50 hover:bg-green-500/5 transition-colors group"
            >
              <div className="text-4xl mb-3 group-hover:scale-110 transition-transform">
                🎓
              </div>
              <h3 className="text-foreground mb-1">Course</h3>
              <p className="text-xs text-muted-foreground">
                Define modules and lessons
              </p>
            </button>
          </div>
        ) : (
          <div className="space-y-4 py-4">
            <div className="space-y-2">
              <Label htmlFor="title">{selectedType} Title</Label>
              <Input
                id="title"
                placeholder={
                  selectedType === "Project"
                    ? "e.g., Build API Backend"
                    : selectedType === "Book"
                    ? "e.g., Deep Work"
                    : "e.g., AWS Solutions Architect"
                }
                className="bg-[#1a1d29] border-[#2a2d3a]"
              />
            </div>

            {selectedType === "Project" && (
              <div className="space-y-2">
                <Label>Roadmap</Label>
                <div className="border-2 border-dashed border-[#2a2d3a] rounded-lg p-8 text-center hover:border-blue-500/50 transition-colors cursor-pointer">
                  <Upload className="w-8 h-8 text-muted-foreground mx-auto mb-2" />
                  <p className="text-sm text-muted-foreground mb-1">
                    Upload roadmap.md or paste content
                  </p>
                  <p className="text-xs text-muted-foreground/70">
                    System will parse milestones and tasks
                  </p>
                </div>
                <Textarea
                  placeholder="Or paste roadmap here..."
                  className="bg-[#1a1d29] border-[#2a2d3a] min-h-32"
                />
              </div>
            )}

            {selectedType === "Book" && (
              <div className="space-y-2">
                <Label>Book Content</Label>
                <div className="border-2 border-dashed border-[#2a2d3a] rounded-lg p-8 text-center hover:border-purple-500/50 transition-colors cursor-pointer">
                  <Upload className="w-8 h-8 text-muted-foreground mx-auto mb-2" />
                  <p className="text-sm text-muted-foreground mb-1">Upload PDF</p>
                  <p className="text-xs text-muted-foreground/70">
                    System will extract chapters
                  </p>
                </div>
                <Input
                  placeholder="Or enter total pages"
                  type="number"
                  className="bg-[#1a1d29] border-[#2a2d3a]"
                />
              </div>
            )}

            {selectedType === "Course" && (
              <div className="space-y-2">
                <Label>Course Structure</Label>
                <div className="bg-[#1a1d29] border border-[#2a2d3a] rounded-lg p-4 space-y-3">
                  <div className="flex gap-2">
                    <Input
                      placeholder="Module name"
                      className="bg-[#0f1117] border-[#2a2d3a]"
                    />
                    <Button variant="outline" size="icon" className="border-[#2a2d3a]">
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>
                  <p className="text-xs text-muted-foreground">
                    Add modules and lessons manually
                  </p>
                </div>
              </div>
            )}

            <div className="grid grid-cols-2 gap-4">
              <div className="space-y-2">
                <Label htmlFor="duration">Duration (weeks)</Label>
                <Input
                  id="duration"
                  type="number"
                  defaultValue="3"
                  className="bg-[#1a1d29] border-[#2a2d3a]"
                />
              </div>

              <div className="space-y-2">
                <Label htmlFor="hoursPerDay">Hours per day</Label>
                <Input
                  id="hoursPerDay"
                  type="number"
                  defaultValue="2"
                  step="0.5"
                  className="bg-[#1a1d29] border-[#2a2d3a]"
                />
              </div>
            </div>

            <div className="bg-blue-500/10 border border-blue-500/30 rounded p-3 text-xs text-blue-400">
              System will auto-generate deadlines and time allocation based on your
              inputs
            </div>

            <div className="flex justify-end gap-2 pt-4">
              <Button
                variant="outline"
                onClick={() => setSelectedType(null)}
                className="border-[#2a2d3a]"
              >
                Back
              </Button>
              <Button onClick={resetAndClose} className="bg-blue-500 hover:bg-blue-600">
                Create {selectedType}
              </Button>
            </div>
          </div>
        )}
      </DialogContent>
    </Dialog>
  );
}
