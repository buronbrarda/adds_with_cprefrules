package java_ui;

import javax.swing.table.TableModel;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;

public class KnowledgePrologLoader implements PrologLoader{

	private TableModel tm;
	private String err_msg;
	private PrologLoader.StatusCode status;
	
	
	private String getAlternative(TableModel tm, int row) {
		return (String) tm.getValueAt(row, 0);
	}
	
	private String [] getCriteria(TableModel tm) {
		
		String [] toReturn = new String [tm.getColumnCount()-1];
		
		for(int i = 1; i < tm.getColumnCount(); i++){
			toReturn[i] = tm.getColumnName(i);
		}
		
		return toReturn;
	}
	
	private String getValue(TableModel tm, int row, int column) {
		return (String) tm.getValueAt(row, column);
	}
	
	
	private void loadAssessment(String alternative, String values) throws PrologLoadException {
		Query q = new Query("add_assessed_alternative", new Term [] {new Atom(alternative), new Atom(values)});
		
		if(!q.hasSolution()) {
			
			this.err_msg = "There was a problem while loading alternative '"+alternative+"'."
					+ "Please, check if the associated criteria and their values are correct."
					+ "Values = "+values+".";
			
			this.status = PrologLoader.StatusCode.Error;
			
			
			throw new PrologLoadException(getErrorMessage());
		};
	}
	
	@Override
	public void loadData(TableModel tm) throws PrologLoadException{
		
		this.tm = tm;
		
		String alternative, values;
		String [] criteria = getCriteria(this.tm);
		
		
		//row(0) = headers
		for(int i = 1; i < tm.getRowCount(); i++) {
			
			alternative = getAlternative(tm, i);
			
			values = "[";
			
			for(int j = 0; j < criteria.length; j++) {
				values = values + "["+criteria[j]+","+getValue(this.tm,i,j+1)+"]";
			}
			
			values = values + "]";
			
			loadAssessment(alternative, values);
		}
	}


	@Override
	public PrologLoader.StatusCode getStatus() {
		return this.status;
	}


	@Override
	public String getErrorMessage() {
		return this.err_msg;
	}
	
	
	
}