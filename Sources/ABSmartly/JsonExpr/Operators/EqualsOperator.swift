final class EqualsOperator: BinaryOperator {
	override func binary(_ evaluator: Evaluator, _ lhs: JSON, _ rhs: JSON) -> JSON {
		if let result = evaluator.compare(lhs, rhs) {
			return JSON(result == 0)
		}
		return JSON.null
	}
}
