import React, { useMemo } from 'react';
import {
    Bar,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    Legend,
    ResponsiveContainer,
    ComposedChart,
} from 'recharts';
import './ScoreGraph.css';

const ScoreGraph = ({ rounds = [] }) => {
    const graphData = useMemo(() => {
        if (!Array.isArray(rounds) || rounds.length === 0) return [];
        return rounds.map((round, index) => ({
            courseName: round.course_name || `Round ${index + 1}`,
            scoreRelativeToPar: round.total_shots - round.total_par,
            totalShots: round.total_shots,
            totalPar: round.total_par,
            holesPlayed: round.holes_played || 18,
            date: round.date_played
                ? new Date(round.date_played).toLocaleDateString()
                : 'Unknown Date'
        }));
    }, [rounds]);

    const performanceSummary = useMemo(() => {
        if (graphData.length === 0) return null;
        const totalRounds = graphData.length;
        const totalScoreDifference = graphData.reduce((sum, round) => sum + round.scoreRelativeToPar, 0);
        const averageScore = totalScoreDifference / totalRounds;
        return {
            totalRounds,
            averageScore: averageScore.toFixed(1),
            overallPerformance: averageScore > 0
                ? 'Above Par'
                : averageScore < 0
                    ? 'Below Par'
                    : 'Consistent Par'
        };
    }, [graphData]);

    if (graphData.length === 0) {
        return <div>No rounds data available for graphing</div>;
    }

    return (
        <div className="stat-graph">
            <div className="graph-header">
                <h2>Golf Performance Analysis</h2>
                {performanceSummary && (
                    <div className="performance-summary">
                        {`${performanceSummary.totalRounds} Rounds | Average Score: ${performanceSummary.averageScore > 0 ? '+' : ''}${performanceSummary.averageScore} (${performanceSummary.overallPerformance})`}
                    </div>
                )}
            </div>

            <div className="graphs-container">
                <div className="graph-section">
                    <h3>Total Shots per Round</h3>
                    <ResponsiveContainer width="100%" height={400}>
                        <ComposedChart data={graphData}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis
                                dataKey="courseName"
                                angle={-45}
                                textAnchor="end"
                                interval={0}
                                height={60}
                            />
                            <YAxis label={{ value: 'Total Shots', angle: -90, position: 'insideLeft' }} />
                            <Tooltip
                                formatter={(value, name, props) => {
                                    if (name === 'Total Shots') {
                                        return [value, `${name} (${props.payload.holesPlayed} holes)`];
                                    }
                                    return [value, name];
                                }}
                            />
                            <Legend />
                            <Bar dataKey="totalShots" fill="#82ca9d" name="Total Shots" barSize={20} />
                        </ComposedChart>
                    </ResponsiveContainer>
                </div>

                <div className="graph-section">
                    <h3>Score Relative to Par per Round</h3>
                    <ResponsiveContainer width="100%" height={400}>
                        <ComposedChart data={graphData}>
                            <CartesianGrid strokeDasharray="3 3" />
                            <XAxis
                                dataKey="courseName"
                                angle={-45}
                                textAnchor="end"
                                interval={0}
                                height={60}
                            />
                            <YAxis label={{ value: 'Strokes Relative to Par', angle: -90, position: 'insideLeft' }} />
                            <Tooltip
                                formatter={(value, name, props) => {
                                    if (name === 'Score vs Par') {
                                        return [
                                            value > 0 ? `+${value}` : value,
                                            `${name} (${props.payload.holesPlayed} holes)`
                                        ];
                                    }
                                    return [value, name];
                                }}
                            />
                            <Legend />
                            <Bar dataKey="scoreRelativeToPar" fill="#8884d8" name="Score vs Par" barSize={20} />
                        </ComposedChart>
                    </ResponsiveContainer>
                </div>
            </div>
        </div>
    );
};

export default ScoreGraph;