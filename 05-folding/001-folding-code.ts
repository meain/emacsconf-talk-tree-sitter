/**
 * Convert preprocessor output for the tag content into MappedCode
 */
function processed_content_to_code(processed: Processed, location: SourceLocation,
            file_basename: string): MappedCode {
	let decoded_map: DecodedSourceMap;
	if (processed.map) {
		decoded_map = decode_map(processed);

		// decoded map may not have sources for empty maps like `{ mappings: '' }`
		if (decoded_map.sources) {
			const source_index = decoded_map.sources.indexOf(file_basename);
			if (source_index !== -1) {
				sourcemap_add_offset(decoded_map, location, source_index);
			}
		}
	}

	return MappedCode.from_processed(processed.code, decoded_map);
}