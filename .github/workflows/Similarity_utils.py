def _process_frames(
    frames: list[dict[str, Any]], frame_metrics: FramesMetrics
) -> tuple[list[str], FramesMetrics]:
    frame_strings = []

    contributing_frames = [
        frame for frame in frames if frame.get("id") == "frame" and frame.get("contributes")
    ]
    contributing_frames = _discard_excess_frames(
        contributing_frames, MAX_FRAME_COUNT, frame_metrics["frame_count"]
    )
    frame_metrics["frame_count"] += len(contributing_frames)

    for frame in contributing_frames:
        frame_dict = extract_values_from_frame_values(frame.get("values", []))
        filename = extract_filename(frame_dict) or "None"

        if not _is_snipped_context_line(frame_dict["context-line"]):
            frame_metrics["found_non_snipped_context_line"] = True

        if not frame_dict["filename"]:
            frame_metrics["has_no_filename"] = True

        if frame_dict["filename"].endswith("html") or "<html>" in frame_dict["context-line"]:
            frame_metrics["html_frame_count"] += 1

        if is_base64_encoded_frame(frame_dict):
            continue

        frame_strings.append(
            f'  File "{filename}", function {frame_dict["function"]}\n    {frame_dict["context-line"]}\n'
        )

    return frame_strings, frame_metrics
