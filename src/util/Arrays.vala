public class Arrays {

	public static bool contains (string[] array, string value) {
		foreach (string current in array)
			if (current == value)
				return true;
		return false;
	}

}
